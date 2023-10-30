extends CActionBase

class_name CActionsGameNext

# инициализировать действие
func _init(name: String).(name) -> void:
	pass

# окончание действия
func end() -> void:
	# метод родителя
	.end();

	# получаем текущий уровень
	var _level = int(CApp.get_scene().get_name().split("_")[1]);
	# поднимаем класс работы с файлами
	var _file = File.new();

	# если есть след. уровень
	if _file.file_exists(
		"res://assets/scenes/locations/Level_" + String(_level + 1) + ".tscn"
	):
		# грузим его
		CApp.change_scene(
			"res://assets/scenes/locations/Level_" + String(_level + 1) + ".tscn"
		);
	
	# если нет
	else:
		# запускаем с первого
		CApp.change_scene(
			"res://assets/scenes/locations/Level_1.tscn"
		);
