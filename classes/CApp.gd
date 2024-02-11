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
	# если сцена подгружена
	if true == _is_loaded_scene:
		# отрабатываем работу контролов
		control.process(delta);

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
	get_tree().quit();

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
