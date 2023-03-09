class_name CControlRule

# имя правила
var _name: String = "";

# клавиша которая отвечает за старт действия
var _start_key: String = "";

# клавиша которая отвечает за окончание действия
var _end_key: String = "";

# допустимые действия для этого рпавила
var _allowed_actions: Array = [];

func _init(
	name: String,
	start_key: String,
	end_key: String = "",
	allowed_actions: Array = []
) -> void:
	_name				= name;
	_start_key			= start_key;
	_end_key			= end_key;
	_allowed_actions	= allowed_actions;

# получить имя действия
func get_name() -> String:
	return _name;

# получить клавишу активации действия
func get_start_key() -> String:
	return _start_key;

# получить клавишу реализации действия
func get_end_key() -> String:
	return _end_key;

# получить допустимые действия для этого правила
func get_allowed_actions() -> Array:
	return _allowed_actions;
	
# есть ли клавиша активации действия
func is_start_key() -> bool:
	return _start_key != "";

# есть ли клавиша окончания действия
func is_end_key() -> bool:
	return _end_key != "";

# есть ли допустимые действия для этого правила
func is_allowed_actions() -> bool:
	return false == _allowed_actions.empty();


