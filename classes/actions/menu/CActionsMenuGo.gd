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
	CApp.audio.play("menu");

# окончание действия
func end() -> void:
	# получаем активную кнопку
	var _button = _entity.menu.get_current_button();
	
	# деактивируем активную кнопку
	_entity.menu.deactivate(_button);
	
	# отностельно напраления
	# переключаем активность кнопок
	match (_direction):
		# если вверх
		"up":
			# активируем пред кнопку
			_entity.menu.activate(
				_entity.menu.get_previous(_button)
			);
		# если вниз
		"down":
			# активируем след кнопку
			_entity.menu.activate(
				_entity.menu.get_next(_button)
			);

	# метод родителя
	.end();
