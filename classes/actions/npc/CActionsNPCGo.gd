extends CActionBase

class_name CActionsNPCGo

# путь
var _path: PoolVector3Array;

# инициализировать действие
func _init(name: String).(name) -> void:
	pass;
	
# первичное действие
func run(_delta: float) -> void:
	# получаем путь
	_path = CApp.grid.get_astar().get_point_path(
		CApp.grid.get_cell_by_position(_entity.global_translation).id,
		_entity.where_we_go().id
	);
	
	# временно блокируем путь
	for i in _path.size():
		 CApp.grid.get_astar().set_point_disabled(
			CApp.grid.get_cell_by_position(_path[i]).id,
			true
		);
	
# процесс действия
func process(delta: float) -> void:
	# если у игроков взят бонус "время"
	if null != CApp.get_scene().get_active_bonus_by_type(CBonus._TIME):
		# выходим из процесса
		return;

	# передвигаем сущность
	if !_path.empty():
		# получаем дистанцию которую танк проедет за кадр
		var _distance = delta * _entity.speed;
		# дистанция до следующей точки
		var _distance_to = _entity.global_translation.distance_to(_path[0]);
		# нарпавление к точке
		var _direction = _entity.global_translation.direction_to(_path[0]);
		
		# направление танка
		# если ось Z ноль, значит двигаемся по оси X
		if _direction.z == 0 && _direction.x != 0:
			# поворачиваем дуло в сторону направления
			_entity.rotation.y = PI/2 if _direction.x < 0 else -PI/2;
		# если ось X ноль, значит двигаемся по оси Z
		elif _direction.x == 0 && _direction.z != 0:
			# поворачиваем дуло в сторону направления
			_entity.rotation.y = 0.0 if _direction.z < 0 else -PI;
			
		# если достигли клетки
		if _distance_to < _distance:
			# сравниваем координаты точки и танка
			_entity.global_translation = _path[0];
			
			# снимаем блок с точки 
			CApp.grid.get_astar().set_point_disabled(
				CApp.grid.get_cell_by_position(_path[0]).id,
				false
			);
			
			# удаляем точку из пути
			_path.remove(0);
			
		# если еще нет
		else:
			# двигаем танк к точке
			_entity.move_and_collide(
				_direction * _distance
			);
		
		# щарим позицию танка
		CApp.share_unreliable(
			_entity,
			"share_position",
			_entity.global_transform
		);
		
	# если точки закончились
	else:
		# завершаем действие
		_entity.actions.end_action(get_name());
	
	# метод родителя
	.process(delta);

# получить набор точек, по которые
# должен проехать НПС
func get_path() -> PoolVector3Array:
	return _path;



