extends Node

# флаг загрузки данных для сцены
var _is_loaded_scene: bool = false;

# контрол первого игрока
var control_1: CControl;

# контрол второго игрока
var control_2: CControl;

# сетка
var grid: CGrid;

# темп
var tmp: CTmp;

# аудио
var audio: CAudio;

# громкость
var volume: float = 0;

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
	control_1 = CControl.new();
	
	# сетка
	grid = CGrid.new();
	
	# говорим, что данные для сцены подгружены
	_is_loaded_scene = true;

# процесс рабоыт приложения
func _physics_process(delta: float) -> void:
	# если сцена подгружена
	if true == _is_loaded_scene:
		# отрабатываем работу контролов
		control_1.process(delta);

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
	tmp.set_value(param, value);

# получить текущую сцену
func get_scene() -> Node:
	return get_tree().get_current_scene();
	
# выход из игры
func quit() -> void:
	get_tree().quit();

