extends Node

# имя сущности
export(String) var entity_name;

# механизм действий
var actions: CActions

# узел готов
func _ready() -> void:
	# поднимаем механизм
	actions = CActions.new(self);
	
	# регаем возмодные действия
	# листаем ввех
	actions.set_action(CActionsMenuGo.new("up", "up"));
	# листаем вниз
	actions.set_action(CActionsMenuGo.new("down", "down"));
	# выбор пункта
	actions.set_action(CActionsMenuSelect.new("select"));

	# регаем менюху в контроллере
	CApp.control_1.set_entity(entity_name, self, [
		[
			CControlRule.new("up", "ui_player_1_up", "ui_player_1_up"),
			CControlRule.new("down", "ui_player_1_down", "ui_player_1_down"),
			CControlRule.new("select", "ui_accept", "ui_accept")
		]
	], true);
	
	# деактивирую все кнопки
	deactivate();
	
	# активирую кнопку
	get_children()[0].activate();
	
# получить выбраную кнопку
func get_current_button() -> Node:
	# листаем все кнопки
	for _button in get_children():
		# если кнопка активна
		if (true == _button.is_active()):
			# вертаем ее
			return _button;
	
	# если кнопку не нашли, то *опа
	return null;

# деактивировать все кнопки
func deactivate() -> void:
	# листаем все кнопки
	for _button in get_children():
		# деактивируем
		_button.deactivate();


