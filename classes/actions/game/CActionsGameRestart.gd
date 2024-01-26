extends CActionBase

class_name CActionsGameRestart

# инициализировать действие
func _init(name: String).(name) -> void:
	pass

# окончание действия
func end() -> void:
	# метод родителя
	.end();

	# сбрасываем буфер
	CApp.tmp.clear_buffer();

	# начальный экран
	CApp.change_scene("res://assets/scenes/locations/MainMenu.tscn");
