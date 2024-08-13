﻿	
Процедура ОбработкаПроведения(Отказ, Режим)    
    Движения.Начисления.Записывать = Истина; 
	Движения.УчетЗатрат.Записывать = Истина;
    Движения.Хозрасчетный.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	
	
	"ВЫБРАТЬ
	|	КадроваяИсторияСотрудниковСрезПоследних.Оклад КАК Оклад
	|ИЗ
	|	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(&период, Сотрудник = &Сотрудник) КАК КадроваяИсторияСотрудниковСрезПоследних"  ;
	
	Запрос.УстановитьПараметр("Период", ЭтотОбъект.ДатаОкончания);
	Запрос.УстановитьПараметр("Сотрудник", ЭтотОбъект.Сотрудник);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ПараметрРасчета = Выборка.Оклад;
	Иначе 
		ПараметрРасчета = 0;
	КонецЕсли;
	
	МесяцНачисления = НачалоМесяца(ЭтотОбъект.ДатаНачала);
	МесяцОкончания = НачалоМесяца(ЭтотОбъект.ДатаОкончания);
	
	Пока МесяцНачисления <= МесяцОкончания Цикл
		
		Движение = Движения.Начисления.Добавить();
		Движение.Сторно = Ложь;
		Движение.ВидРасчета = ПланыВидовРасчета.Начисления.Больничный;
		Движение.ПериодДействияНачало = Макс(ЭтотОбъект.ДатаНачала, МесяцНачисления);
		Движение.ПериодДействияКонец = Мин(ЭтотОбъект.ДатаОкончания, КонецМесяца(МесяцНачисления));
		Движение.ПериодРегистрации = ЭтотОбъект.ПериодНачисления;
		Движение.БазовыйПериодНачало = Макс(ЭтотОбъект.ДатаНачала, МесяцНачисления);
		Движение.БазовыйПериодКонец = Мин(ЭтотОбъект.ДатаОкончания, КонецМесяца(МесяцНачисления));
		Движение.Сотрудник = ЭтотОбъект.Сотрудник;
		Движение.ПоказательРасчета = ПараметрРасчета;  
		
		МесяцНачисления = ДобавитьМесяц(МесяцНачисления, 1);
	КонецЦикла;
	
	Движения.Начисления.Записать();
	Движения.Начисления.РассчитатьСуммуНачисления();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	
	"ВЫБРАТЬ
	|	Начисления.Сотрудник КАК Сотрудник,
	|	СУММА(Начисления.Сумма) КАК Сумма,
	|	Начисления.ВидРасчета.СтатьяЗатрат КАК СтатьяЗатрат
	|ИЗ
	|	РегистрРасчета.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.Регистратор = &Регистратор
	|
	|СГРУППИРОВАТЬ ПО
	|	Начисления.Сотрудник,
	|	Начисления.ВидРасчета.СтатьяЗатрат";
	
	Запрос.УстановитьПараметр("Регистратор", ЭтотОбъект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();    
	
	ДвижениеЗатрат = Движения.УчетЗатрат.Добавить();
	ДвижениеЗатрат.Период = Дата;
	ДвижениеЗатрат.Сумма = Выборка.Сумма;
	ДвижениеЗатрат.СтатьяЗатрат = Выборка.СтатьяЗатрат;
	
	  	
    ДвижениеХозрасчетный = Движения.Хозрасчетный.Добавить();
	ДвижениеХозрасчетный.СчетДт = ПланыСчетов.Хозрасчетный.РасходыНаПродажу;     
	ДвижениеХозрасчетный.СчетКт = ПланыСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда;
	ДвижениеХозрасчетный.Период = Дата;        
	ДвижениеХозрасчетный.Сумма = Выборка.Сумма;        
	ДвижениеХозрасчетный.Содержание = "Отражено начисление по больничному листу";
	БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(ДвижениеХозрасчетный.СчетДт, ДвижениеХозрасчетный.СубконтоДт, Выборка.СтатьяЗатрат);
	БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(ДвижениеХозрасчетный.СчетКт, ДвижениеХозрасчетный.СубконтоКт, Выборка.Сотрудник);

    
КонецПроцедуры   

	
