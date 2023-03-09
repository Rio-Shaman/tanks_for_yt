class_name CControl

# список сущностей, на которые
# может влиять управление
var _entities: Dictionary = {};

# текущая сущность для манипуляции.
# манипуляции ведутся с последним элементом
# массива
var _current_entities: Array = [];

# потоки
var _threads: Dictionary = {};

# метод позволяет мониторить какие либо
# изменения раз в кадр
func process(delta: float) -> void:
	# если есть текущая сущность
	if true == has_current_entity():
		# действия (CActions)
		var _actions = get_current_entity().actions;
		
		# если есть НЕ потоковые действия
		if true == _actions.has_current_action():
			# запускаем процесс
			_actions.get_current_action().process(delta);
			
		# если НЕ потоковых действий нет
		else:
			# листаем потоки
			for _thread in _threads[get_current_entity_name()]:
				# исполняем
				_thread.process(delta);
	
# метод позволяет запомнить сущность
# в справочнике сущностей
func set_entity(
	name: String,
	entity: Object,
	threads: Array,
	current: bool = false
) -> void:
	# если сущности нет в стеке
	if false == _entities.has(name):
		# добавляем
		_entities[name] = entity;
		
	# если нет потоков у сущности
	if false == _threads.has(name):
		# создаем массив потоков
		_threads[name] = [];
		
		# начальный номер потока
		var _number: int = 0;

		# листаем присланные потоки
		for _rules in threads:
			# регестрирую поток у сущности
			_threads[name].append(CThread.new(
				_number, _rules, entity
			));
			
			# переключаем поток
			_number += 1;
		
	# если сущность необходимо отправить в стек
	if true == current:
		# отправляем
		set_current_entity(name);
		
# передаем управление новой сущности
func set_current_entity(name: String) -> void:
	# завершаем все действия которые управляются клавишами
	# переменная для правила
	var _rule: CControlRule;
	
	# если есть текущая сущность
	if true == has_current_entity():
		# листаем потоки
		for _thread in _threads[get_current_entity_name()]:
			# листаем действия потока
			for _action in get_current_entity().actions.get_current_actions(
				_thread.get_number()
			):
				# получаем правило действия
				_rule = _thread.get_current_rule(_action.get_name());
				
				# есть ли клавиша завершения
				if true == _rule.is_end_key():
					# завершаем действие
					get_current_entity().actions.end_action(
						_action.get_name()
					);
		
	# передаем управление новой сущности
	_current_entities.append(name);

# существует ли текущая сущность
func has_current_entity() -> bool:
	return false == _current_entities.empty();

# закрыть текущую сущность, передать управление
# предыдущей сущности
func close_current_entity() -> void:
	_current_entities.pop_back();

# метод возвращает имя текущей сущности
func get_current_entity_name() -> String:
	return _current_entities.back();

# метод возвращает текущую сущность
func get_current_entity() -> Node:
	return _entities[
		get_current_entity_name()
	];


