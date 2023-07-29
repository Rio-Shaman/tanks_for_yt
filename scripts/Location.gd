extends Spatial

# первая точка респа
export var respawn_1: String;

# вторая точка респа
export var respawn_2: String;

# третья точка респа
export var respawn_3: String;

# танки на уровне
var respawns: Array;

# механизм действий
var actions: CActions;

# список бонусов
var _bonuses: Array = [
	"Upgrade",
	"Life",
	"Time",
	"Destroy",
	"Base_Armor",
	"Ship",
	"Armor"
];

# инициализация
func _init():
	# подгружаем первичные
	# данные сцены
	CApp.load_scene();

# узел готов
func _ready() -> void:
	# загружаем сетку
	CApp.grid.load_grid();
	
	# наполняем первый ангар танками
	respawns.append(get_respawn_data(respawn_1));
	# наполняем второй ангар танками
	respawns.append(get_respawn_data(respawn_2));
	# наполняем третий ангар танками
	respawns.append(get_respawn_data(respawn_3));
	
	# поднимаем механизм действий
	actions = CActions.new(self);
	
	# регаем действие подгрузки вражеского танка
	actions.set_action(CActionsNPCLoad.new('load'));
	
	# скрываем бронированную стену вокруг базы
	get_node("Map/Base/Armored").visible = false;
	# у блоков стен
	for _wall in get_node("Map/Base/Armored").get_children():
		# удаляем коллизию
		_wall.set_collision_layer_bit(0, false);
	
# раз в кадр
func _physics_process(delta: float) -> void:
	# если НЕТ действие
	if false == actions.has_current_action():
		if true == is_revive_tank():
			# стартуем действие "возродить"
			actions.set_current_action("load", delta);
			# запускаем процесс
			actions.get_current_action().process(delta);
	
	# если уже ЕСТЬ действие
	else:
		# продолжаем исполнять действие
		actions.get_current_action().process(delta);
	
	# если на карте нет врагов и ангар пуст
	if false == has_enemies() && true == respawns_empty():
		print("на след уровень!");

# получить данные респа
func get_respawn_data(string: String) -> Array:
	return Array(string.split(",")) if string != "" else [];

# нужно ли возродить вражеский танк
func is_revive_tank() -> bool:
	# если в ангере НЕТ танков
	if true == respawns_empty():
		# грузить танки НЕ нужно
		return false;
	
	# если кол-во танков меньше трех
	# то танкаов на карте НЕ достаточно
	return get_enemies().size() < 3;

# есть ли еще танки в ангарах
func respawns_empty() -> bool:
	return (
			respawns[0].size() == 0
		&&	respawns[1].size() == 0
		&&	respawns[2].size() == 0
	);

# есть ли враги на карте
func has_enemies() -> bool:
	return false == get_enemies().empty();

# получить танки врагов
func get_enemies() -> Array:
	return CApp.get_tree().get_nodes_in_group("NPC");
	
# получить танки игроков
func get_players() -> Array:
	return CApp.get_tree().get_nodes_in_group("Players");

# получить следующий вражеский танк
func get_next_tank() -> Dictionary:
	
	# точка респа
	var _respawn: Dictionary;
	
	# выбираю респ (ангар) в котором больше всего танков
	# листаю точки респа (ангары)
	for i in respawns.size():
		# если точка респа НЕ определена
		# или кол-во танков в сохраненной точке
		# меньше чем в листаемой
		if _respawn.size() == 0 || _respawn.get("count") < respawns[i].size():
			# сохраняем данные листаемого респа
			_respawn = {
				# ключ в массиве респа (сво-во respawns)
				"key": i,
				# номер точки респа
				"respawn": i + 1,
				# кол-во танков на респе (в ангаре)
				"count": respawns[i].size()
			};
	
	return {
		"type": respawns[_respawn.get("key")].pop_back(),
		"respawn": _respawn.get("respawn")
	};

# получить активный бонус на сцене
func get_active_bonus_by_type(type: int) -> Node:
	# листаем бонусы
	for _child in CApp.get_tree().get_nodes_in_group("Bonuses"):
		# если типы совпадают и в бонус записан игрок
		if _child.get_type() == type && null != _child.get_player():
			# возвращаем бонус
			return _child;

	return null;

# получить все НЕ активные бонусы на сцене
func get_not_active_bonuses() -> Array:
	# коллекция бонусов
	var collect: Array = [];
	
	# листаем бонусы
	for _child in CApp.get_tree().get_nodes_in_group("Bonuses"):
		# если в бонус НЕ записан игрок
		if null == _child.get_player():
			# сохраняем бонус
			collect.append(_child);
			
	return collect;

# сгенерировать бонус
func generate_bonus() -> void:
	# бонус
	var _bonus: Node;
	# ячейка для спавна бонуса
	var _cell: Dictionary;
	# получаем рандомный тип бонуса
	var _type = randi() % 7;
	# получаем игроков
	var players = get_players();

	# листаем все НЕ активные бонусы
	for _node in get_not_active_bonuses():
		# уничтожаем бонус
		_node.free();

	# бесконечный цикл
	while true:
		# получаем ячейку
		_cell = CApp.grid.get_cell_by_type(CApp.grid._BONUS, 0);
		
		# если игроков нет на этой ячейке
		if (false == CApp.grid.is_node_in_cell(players[0], _cell)):
			# завершаем цикл
			break;

	# поднимаем бонус по типу
	_bonus = load(
		"res://assets/scenes/bonuses/" + _bonuses[_type] + ".tscn"
	).instance();

	# назначаем координаты ячейки бонусу
	_bonus.set_translation(_cell.vector);

	# определяем бонус в группу Bonuses
	_bonus.add_to_group("Bonuses");

	# грузим на сцену
	add_child(_bonus);


