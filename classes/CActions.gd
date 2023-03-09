class_name CActions

# текущее активное действие.
# в качестве активного берется последний
# элемент массива
var _current_actions: Array = [];

# объекты действий
var _actions: Dictionary = {};

# сущность над которой проводятся манипуляции
var _entity: Object;

# потоки
var _threads: Dictionary = {};

# поднять объект действий
func _init(entity: Object) -> void:
	_entity = entity;

# добавть действие
func set_action(action: CActionBase) -> void:
	# передаем сущность в действие
	action.set_entity(_entity);
	# сохраняем объект в сво-ве действий
	_actions[action.get_name()] = action;

# установить действие в справочник
func set_current_action(action: String, delta: float, thread: int = -1) -> void:
	# если в стеке есть действия
	if has_current_action(thread):
		# и происходит повторный запуск действия
		if get_current_action(thread).get_name() == action:
			# предотвращаем это
			return;
	
	# регаем действие в стеке
	_current_actions.append(action);
	# запускаем первичный метод
	_actions[action].run(delta);
	
# существует ли текущее действие
func has_current_action(thread: int = -1) -> bool:
	# если проверяем список ВНЕ потока
	if thread == -1:
		return false == _get_current_actions_without_thread().empty();
	
	# есть ли активные действия потока
	return false == _get_current_actions_by_thread(thread).empty();
	
	
# получить активное действие
func get_current_action(thread: int = -1) -> Reference:
	# если проверяем список ВНЕ потока
	if thread == -1:
		return _actions[
			_get_current_actions_without_thread().back()
		];
	
	# получаем из списка потока
	return _actions[
		_get_current_actions_by_thread(thread).back()
	];
	
# завершить действие
func end_action(name: String) -> void:
	_current_actions.erase(name);
	_actions[name].end();
	
# завершить (сбросить) все действия
func end_all_actions() -> void:
	_current_actions = [];

# получить всe действия (именно объекты действий), от
# текущего к предыдущему
func get_current_actions(thread: int = -1) -> Array:
	# получаем список текущих действий по потоку
	var current_actions: Array = [];
	
	# если смотрим список ВНЕ потока
	if thread == -1:
		current_actions = _get_current_actions_without_thread();
	else:
		current_actions = _get_current_actions_by_thread(thread);
		
	# переворачиваем массив
	current_actions.invert();
	
	# собираем действия в коллекцию
	var collect = [];
	for i in current_actions:
		collect.append(_actions[i]);
		
	return collect;

# получить действия не прикрепленные к потокам
func _get_current_actions_without_thread() -> Array:
	# коллеция
	var _collect: Array = [];
	
	# все действия потоков
	var _thread_actions = [];
	
	# собираем все действия потоков в кучу
	for _thread in _threads:
		for _action in _threads[_thread]:
			_thread_actions.append(_action);
			
	# листаем активные действия
	for _action in _current_actions:
		# если действия НЕТ в списках потоковых
		# действий
		if false == (_action in _thread_actions):
			_collect.append(_action);
	
	# возвращаем коллекцию
	return _collect;

# получаем активные действия потока
func _get_current_actions_by_thread(number: int) -> Array:
	# коллеция
	var _collect: Array = [];
	
	# если нет данных о потоке
	if false == _threads.has(String(number)):
		return _collect;

	# листаем текущие действия
	for _action in _current_actions:
		# если действие есть в потоке
		if true == (_action in _threads.get(String(number))):
			# сохраняем действие в коллекцию
			_collect.append(_action);

	# возвращаем коллекцию
	return _collect;

# связываем поток и действие
func set_thread_action(number: int, name: String) -> void:
	# если данных нет
	if false == _threads.has(String(number)):
		_threads[String(number)] = [];
		
	_threads[String(number)].append(name);


