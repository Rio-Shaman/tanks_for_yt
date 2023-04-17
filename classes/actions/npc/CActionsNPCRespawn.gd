extends CActionBase

class_name CActionsNPCRespawn

# инициализировать действие
func _init(name: String).(name) -> void:
	pass
	
# процесс действия
func process(delta: float) -> void:
	# получаем дистанцию которую танк проедет за кадр
	var _distance = delta * _entity.speed;
	# дистанция до респа
	var _distance_to = _entity.global_translation.distance_to(_entity.respawn_point);
	
	# если достигли клетки
	if _distance_to < _distance:
		# сравниваем координаты точки и танка
		_entity.global_translation = _entity.respawn_point;
		# включаю реакцию на мир
		_entity.set_collision_mask_bit(0, true);
		# завершаем действие
		_entity.actions.end_action(get_name());
	# если еще нет
	else:
		# двигаем танк к точке
		_entity.move_and_collide(
			Vector3(0, 0, _distance)
		);

	# метод родителя
	.process(delta);

