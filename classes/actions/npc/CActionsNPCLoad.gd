extends CActionBase

class_name CActionsNPCLoad

# инициализировать действие
func _init(name: String).(name) -> void:
	pass;
	
# первичное действие
func run(_delta: float) -> void:
	# стартуем задержку
	start_timer(0.5);
	
	# получаем танк
	var _tank: Dictionary = _entity.get_next_tank();
	
	# получаем вражеский танк
	var _npc = load(
		"res://assets/scenes/npc/NPC_" + _tank.type + ".tscn"
	).instance();
	
	# по типу танка...
	match _tank.type:
		"1", "2":
			# ... назанчаем скорость 3
			_npc.speed = 3;
		_:
			# ... назанчаем скорость 2
			_npc.speed = 2;
	
	# назначаем хп
	_npc.hp = int(_tank.type);
	
	# сохраняем тип танка
	_npc.type = int(_tank.type);
	
	# точка респа
	_npc.respawn_point = CApp.grid.get_cell_by_type(
		CApp.grid._RESPAWN, _tank.respawn
	).vector;
	
	# сохраняю позицию танка
	_npc.set_translation(
		_npc.respawn_point - Vector3(0, 0, 2 * CApp.grid.get_cell_size().z)
	);
	
	# разворачиваю танк
	_npc.rotation.y = -PI;
	
	# определяем танк в группу NPC
	_npc.add_to_group("NPC");
	
	# грузим танк на сцену
	CApp.get_scene().add_child(_npc);

# процесс действия
func process(delta: float) -> void:
	# метод родителя
	.process(delta);

	# если таймер истек
	if is_timer_out():
		_entity.actions.end_action(get_name());

