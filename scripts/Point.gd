extends Node

class_name CPoint

# следующая кнопка
export(NodePath) var _next;

# предыдущая кнопка
export(NodePath) var _previous;

# активный ли пункт
var _active: bool = false;

# получить след кнопку
func get_next() -> Node:
	return _next;
	
# получить предыдущую кнопку
func get_previous() -> Node:
	return _previous;

# активен ли пункт
func is_active() -> bool:
	return _active;
	
# изменить активность
func set_active(value: bool) -> void:
	_active = value;

# деактивировать кнопку
func deactivate() -> void:
	set_active(false);

# активировать кнопку
func activate() -> void:
	set_active(true)

# активировать кнопку
func select() -> void:
	print("Выбрали " + get_name());
