extends CActionBase

class_name CActionsMenuSelect

# инициализировать действие
func _init(name: String).(name) -> void:
	pass;
	
# первичное действие
func run(_delta: float) -> void:
	# проиграть звук
	pass;

# окончание действия
func end() -> void:
	
	# получаем активную кнопку
	var _button = _entity.get_current_button();
	
	# вызываю обработчик
	_button.select();
	
	# метод родитель
	.end();
