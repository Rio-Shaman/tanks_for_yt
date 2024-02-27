extends CActionBase

class_name CActionsMenuSelect

# инициализировать действие
func _init(name: String).(name) -> void:
	pass;
	
# первичное действие
func run(_delta: float) -> void:
	# проиграть звук
	CApp.audio.play("menu");

# окончание действия
func end() -> void:
	# вызываю обработчик
	_entity.menu.select();

	# метод родитель
	.end();
