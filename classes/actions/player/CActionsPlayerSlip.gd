extends CActionBase

class_name CActionsPlayerSlip

# направление
var _direction: String;

# инициализировать действие
func _init(name: String).(name) -> void:
	pass
	
# первичное действие
func run(_delta: float) -> void:
	var _vector = _entity.global_transform.basis.z;
	
	# если ось Z ноль, то двигаемся по оси X
	if int(_vector.z) == 0:
		_direction = "right" if _vector.x == -1 else "left";
		
	# если ось X ноль, то двигаемся по оси Z
	elif int(_vector.x) == 0:
		_direction = "down" if _vector.z == -1 else "up";
	
	# таймер скольжения
	start_timer(0.3);

# процесс действия
func process(delta: float) -> void:
	# метод родителя
	.process(delta);

	# передвигаем сущность
	match _direction:
		"left":
			_entity.move_and_collide(
				Vector3(-delta * _entity.speed, 0, 0)
			);
		"right":
			_entity.move_and_collide(
				Vector3(delta * _entity.speed, 0, 0)
			);
		"up":
			_entity.move_and_collide(
				Vector3(0, 0, -delta * _entity.speed)
			);
		"down":
			_entity.move_and_collide(
				Vector3(0, 0, delta * _entity.speed)
			);

	# если таймер истек
	if is_timer_out():
		# завершаем действие
		_entity.actions.end_action(get_name());
	
# окончание действия
func end() -> void:
	# родитель
	.end();

