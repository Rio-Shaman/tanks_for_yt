class_name CActionBase

# имя действия
var _name: String;

# флаг "таймер в ожидании"
var _timer_waiting: bool = false;

# текущий таймер
var _current_timer: float = 0;

# сущность для которой преднозначено
# действие (игрок, нпс, панель и т.д.)
var _entity: Object;

# инициализировать действия
func _init(name: String) -> void:
	_name = name;

# первичный запуск действия
func run(_delta: float) -> void:
	pass;

# процесс действия
func process(delta: float) -> void:
	# если таймер НЕ на стопе
	if false == timer_stopped():
		# уменьшаем таймер на дельту
		_current_timer -= delta;

# окончание действия
func end() -> void:
	# принудительный сброс таймера
	reset_timer();
	
# получить имя действия
func get_name() -> String:
	return _name;

# старт таймера (или выход из режима ожидания)
func start_timer(timer: float = -1) -> void:
	_current_timer = timer if timer != -1 else _current_timer;
	_timer_waiting = false;
	
# стоит ли таймер на паузе
func timer_stopped() -> bool:
	return _timer_waiting;

# стоп таймер
func stop_timer() -> void:
	_timer_waiting = true;
	
# принудительный сброс таймера
func reset_timer() -> void:
	_current_timer = 0;
	_timer_waiting = false;

# истек ли таймер
func is_timer_out() -> bool:
	return _current_timer <= 0;

# получить текущий таймер
func get_current_timer() -> float:
	return _current_timer;
	
# сущность для манипуляций
func set_entity(entity: Object) -> void:
	_entity = entity;



