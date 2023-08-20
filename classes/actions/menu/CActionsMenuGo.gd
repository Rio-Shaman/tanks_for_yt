extends CActionBase

class_name CActionsMenuGo

# направление
var _direction: String;

# инициализировать действие
func _init(name: String, direction).(name) -> void:
	# запоминаем направление
	_direction = direction;
	
# первичное действие
func run(_delta: float) -> void:
	# проиграть звук
	pass;

# окончание действия
func end() -> void:
	# получаем активную кнопку
	var _button = _entity.get_current_button();
	
	# деактивируем текущую кнопку
	_button.deactivate();
	
	# отностельно напраления
	# переключаем активность кнопок
	match (_direction):
		# если вверх
		"up":
			# активируем пред кнопку
			_button.get_node(_button.get_previous()).activate();
		# если вниз
		"down":
			# активируем след кнопку
			_button.get_node(_button.get_next()).activate();

	# метод родителя
	.end();
