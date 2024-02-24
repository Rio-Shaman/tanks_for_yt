extends Label3D

export var _number: int;

# механизм действий
var actions: CActions;

# узел готов
func _ready() -> void:
	# прчем надпись
	visible = false;
	
	# узел игрока
	var _player = CApp.get_scene().get_node("Player_" + String(_number));

	# если игрок бот
	if true == _player.is_bot(_number):
		# ничего делать не нужно
		return;

	# окно паузы
	var window_pause = CApp.get_scene().get_node("Map/UI/Pause");
	# окно гейм овер
	var window_gameover = CApp.get_scene().get_node("Map/UI/GameOver");
	# окно итоги
	var window_congratulation = CApp.get_scene().get_node("Map/UI/Congratulation");
	# окно дисконнекта
	var window_disconnected = CApp.get_scene().get_node(
		"Map/UI/DisconnectedPlayer" + ("2" if _number == 1 else "1")
	);

	# поднимаем механизм
	actions = CActions.new(self);
	
	# регаем возможные действия игрока
	actions.set_action(CActionsWindowOpen.new("pause", window_pause));
	actions.set_action(CActionsWindowOpen.new(
		"disconnected_player_" + ("2" if _number == 1 else "1"),
		window_disconnected
	));

	# если игрок 1
	if _number == 1:
		actions.set_action(CActionsWindowOpen.new("gameover", window_gameover));
		actions.set_action(CActionsWindowOpen.new("congratulation", window_congratulation));

	# регаем игрока в контроллере
	CApp.control.set_entity('gameover_player', self, [
		[
			CControlRule.new("pause", "ui_player_1_accept", "ui_player_1_accept")
		]
	]);
