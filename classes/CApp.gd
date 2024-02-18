extends Node

# флаг загрузки данных для сцены
var _is_loaded_scene: bool = false;

# контрол игрока
var control: CControl;

# сетка
var grid: CGrid;

# темп
var tmp: CTmp;

# аудио
var audio: CAudio;

# громкость
var volume: float = 0;

# является ли "мир" сервером
var _is_server: bool = false;

# порт
var _port: int = 7777;

# upnp
var _upnp: UPNP;

# дельта
var _delta: float;

# уникальный номер
var _unique_number: int = 0;

# узел готов
func _ready() -> void:
	# скрыть мышь
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN);
	
	# НЕ ставить процессм на паузу
	set_pause_mode(PAUSE_MODE_PROCESS);
	
	# поднимаем темп
	tmp = CTmp.new();
	
# загрузка данных для сцены
func load_scene() -> void:
	# контролы
	control = CControl.new();
	
	# сетка
	grid = CGrid.new();
	
	# говорим, что данные для сцены подгружены
	_is_loaded_scene = true;

# процесс рабоыт приложения
func _physics_process(delta: float) -> void:
	# сохраняем дельту
	_delta = delta;
	
	# если игра готова
	if true == is_ready():
		# отрабатываем работу контрола
		control.process(_delta);

# пауза
func paused() -> void:
	get_tree().set_pause(
		!is_paused()
	);
	
# на паузе ли проект
func is_paused() -> bool:
	return get_tree().is_paused();

# смена сцены
func change_scene(scene: String) -> void:
	# говорим, что данные для сцены НЕ подгружены
	_is_loaded_scene = false;
	
	# грузим новую сцену
	var _error = get_tree().change_scene(scene);

# получить данные из темпа
func get_from_tmp(param: String, default: String = "") -> String:
	# значение
	return tmp.get_value(param, default);

# сохраняем данные в темп
func save_in_tmp(param: String, value: String) -> void:
	# сохраняем
	tmp.set_value(param, value);
	
# удаляем данные из темпа
func destroy_from_tmp(param: String) -> void:
	# удаляем параметр
	tmp.destroy_value(param);

# получить текущую сцену
func get_scene() -> Node:
	return get_tree().get_current_scene();
	
# выход из игры
func quit() -> void:
	# удпляем пробросанный порт
	# delete_port();
	# закрываем игру
	get_tree().quit();

# уведомление
func _notification(what: int) -> void:
	# если ОС пытается закрыть игру
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		# удаляем порт
		# delete_port();
		pass;

# проверка игры, является ли она
# онлайн
func is_online() -> bool:
	# если игра на двоих
	return get_from_tmp("player2.active", "0") == "1";

# проверка "мира" является ли он мастером
# или клиентом
func is_master() -> bool:
	# если игра оффлайн
	if false == is_online():
		# то да, это единственный "мир"
		return true;
	
	# определяем сервер ли
	return _is_server;

# пробрасываем порт
func add_port() -> void:
	# поднимаем UPNP
	var upnp = UPNP.new();
	# сканируем девайсы
	var result = upnp.discover();
	# если успех
	if result == UPNP.UPNP_RESULT_SUCCESS:
		# получаем девайс (дефорлт) и регаем порт
		upnp.get_gateway().add_port_mapping(
			_port, 0, ProjectSettings.get_setting("application/config/name")
		);
		# сохраняю UPNP
		_upnp = upnp;

# удаляем порт
func delete_port() -> void:
	# если upnp использовался
	if null != _upnp:
		var _r = _upnp.get_gateway().delete_port_mapping(_port);

# назначаем "мир" как сервер или клиент
func set_server(_value: bool) -> void:
	_is_server = _value;

# получить порт
func get_port() -> int:
	return _port;

# проверка по регулярному выражению
func regex(value: String, _pattern: String) -> bool:
	# поднимаем объект
	var _regex = RegEx.new();
	# компилируем паттерн
	_regex.compile(_pattern);
	# проверяем совпадает ли
	return false == (null == _regex.search(value));

# получить дельту
func get_delta() -> float:
	return _delta;

# шарим данные
func share(
	_object: Node,
	_method: String,
	_arg1 = null,
	_arg2 = null,
	_arg3 = null,
	_arg4 = null,
	_reliable = true
) -> void:
	# если игра оффлайн
	if false == is_online():
		# то шарить ничего не нужно
		return;
	
	# каким методом будет отправлять
	var _f = "rpc" if true == _reliable else "rpc_unreliable";

	call(
		# rpc или rpc_unreliable
		_f,
		# удаленный метод в CApp, для общения
		"remote_method_call",
		# путь к узлу (Node)
		_object.get_path(),
		# метод который нужно дергать
		_method,
		# аргументы которые нужно передать
		_arg1, _arg2, _arg3, _arg4
	);

# шарим данные
func share_unreliable(
	_object: Node,
	_method: String,
	_arg1 = null,
	_arg2 = null,
	_arg3 = null,
	_arg4 = null
) -> void:
	share(_object, _method, _arg1, _arg2, _arg3, _arg4, false);

# единый метод ля удаленного дерганья методов
remote func remote_method_call(
	_path: String,
	_method: String,
	_arg1 = null,
	_arg2 = null,
	_arg3 = null,
	_arg4 = null
) -> void:
	# есть ли запрашиваемый узел
	if false == get_scene().has_node(_path):
		# если нет, обрываем работу метода
		return;
		
	# получаю Node
	var _node = get_scene().get_node(_path);

	# если НЕТ аргументов
	if _arg1 == null && _arg2 == null && _arg3 == null && _arg4 == null:
		# вызываем без аргументов
		_node.call(_method);
	# если 1 аргумент
	if _arg1 != null && _arg2 == null && _arg3 == null && _arg4 == null:
		# вызываем с 1-им аргументом
		_node.call(_method, _arg1);
	# если 2 аргумента
	if _arg1 != null && _arg2 != null && _arg3 == null && _arg4 == null:
		# вызываем с 2-я аргументами
		_node.call(_method, _arg1, _arg2);
	# если 3 аргумента
	if _arg1 != null && _arg2 != null && _arg3 != null && _arg4 == null:
		# вызываем с 3-я аргументами
		_node.call(_method, _arg1, _arg2, _arg3);
	# если 4 аргумента
	if _arg1 != null && _arg2 != null && _arg3 != null && _arg4 != null:
		# вызываем с 4-я аргументами
		_node.call(_method, _arg1, _arg2, _arg3, _arg4);

# готова ли игра
func is_ready() -> bool:
	# если ...
	if (
		# ... игра онлайн ...
			true == is_online()
		# ... и есть игроки на сцене
		&&	false == get_tree().get_nodes_in_group("Players").empty()
	):
		# листаем игроков
		for _player in get_tree().get_nodes_in_group("Players"):
			# если хотя бы 1 из игроков НЕ готов
			if false == _player.is_ready():
				# то говорим что игра еще НЕ готова
				return false;
	
	# в остальных случаях все
	# зависит от флага _is_loaded_scene
	return _is_loaded_scene;

# выдать уникальное имя
func get_unique_name(_prefix: String = "UniqueName") -> String:
	# формируем уникальное имя
	var _unique_name = _prefix + "_" + String(_unique_number);
	# переключаем ID
	_unique_number += 1;

	# возвращаем уникальное имя
	return _unique_name;

# удаленный рычаг для смены сцены
func share_change_scene(scene: String) -> void:
	# меняем сцену
	change_scene(scene);

