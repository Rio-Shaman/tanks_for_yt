extends CActionBase

class_name CActionsGameNext

# инициализировать действие
func _init(name: String).(name) -> void:
	pass

# окончание действия
func end() -> void:
	# метод родителя
	.end();
	
	# если игра крашнулась
	if true == CApp.get_scene().is_game_crashed():
		# запускаем действие "закрыть окно"
		_entity.actions.set_current_action("close", CApp.get_delta());
		# завершаем действие руками
		_entity.actions.end_action("close");
		# обрываем метод
		return;

	# если "мир" 2
	#if false == CApp.is_master():
		# обрываем метод
		# 2-ому игроку нельзя переходить на
		# след уровень
	#	return;

	# получаем текущий уровень
	var _level = int(CApp.get_scene().get_name().split("_")[1]);
	# поднимаем класс работы с файлами
	var _file = File.new();
	# след уровня
	var _next_level: int = 1;

	# если есть след. уровень
	if _file.file_exists(
		"res://assets/scenes/locations/Level_" + String(_level + 1) + ".tscn"
	):
		# переключаем номер уровня
		_next_level = _level + 1;
		
	# дернуть след уровен
	#CApp.share(
	#	CApp,
	#	"share_change_scene",
	#	"res://assets/scenes/locations/Level_" + String(_next_level) + ".tscn"
	#);

	# грузим след уровень
	CApp.change_scene(
		"res://assets/scenes/locations/Level_" + String(_next_level) + ".tscn"
	);
