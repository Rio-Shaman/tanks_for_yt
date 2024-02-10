extends CActionBase

class_name CActionsPlayerRespawn

# инициализировать действие
func _init(name: String).(name) -> void:
	pass
	
# первичное действие
func run(_delta: float) -> void:
	# включаем коллизию
	_entity.get_node("CollisionShape").disabled = false;
	# разворачиваем танк
	_entity.rotation.y = 0;
	# создаем новую модель танка
	_entity.update();

# процесс действия
func process(delta: float) -> void:
	# получаем точку респа
	var _respawn_point = CApp.grid.get_cell_by_type(
		CApp.grid._PLAYER_1 if _entity.number == 1 else CApp.grid._PLAYER_2
	).vector;
	
	# получаем дистанцию которую танк проедет за кадр
	var _distance = delta * _entity.speed;
	# дистанция до респа
	var _distance_to = _entity.global_translation.distance_to(_respawn_point);
	
	# если достигли клетки
	if _distance_to < _distance:
		# сравниваем координаты точки и танка
		_entity.global_translation = _respawn_point;
		# включаю реакцию на мир
		_entity.set_collision_mask_bit(0, true);
		# завершаем действие
		_entity.actions.end_action(get_name());
	# если еще нет
	else:
		# двигаем танк к точке
		_entity.move_and_collide(
			Vector3(0, 0, -_distance)
		);

	# метод родителя
	.process(delta);

# окончание действия
func end() -> void:
	# метод родителя
	.end();


