﻿Процедура ЗаполнитьГрафики(ДанныеГрафика) Экспорт
	
	Для Каждого СтрокаГрафика Из ДанныеГрафика Цикл
		ЗаписьДня = СоздатьМенеджерЗаписи();
		ЗаписьДня.День = СтрокаГрафика.День;
		ЗаписьДня.КоличествоЧасов = СтрокаГрафика.КоличествоЧасов;
		ЗаписьДня.График = СтрокаГрафика.Ссылка;
		ЗаписьДня.Записать(Истина);
	КонецЦикла;        
		
КонецПроцедуры