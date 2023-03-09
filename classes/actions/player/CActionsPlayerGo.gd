extends CActionBase

class_name CActionsPlayerGo

# направление
var _direction: String;

# инициализировать действие
func _init(name: String, direction: String).(name) -> void:
	# запоминаем направление
	_direction = direction;
	
# первичное действие
func run(_delta: float) -> void:
	# ротация
	match _direction:
		"left":
			_entity.rotation.y = PI/2;
		"right":
			_entity.rotation.y = -PI/2;
		"up":
			_entity.rotation.y = 0;
		"down":
			_entity.rotation.y = -PI;
	
# процесс действия
func process(delta: float) -> void:

	# столкновение
	var _is_colliding: KinematicCollision;

	# передвигаем сущность
	match _direction:
		"left":
			_is_colliding = _entity.move_and_collide(
				Vector3(-delta * _entity.speed, 0, 0)
			);
		"right":
			_is_colliding = _entity.move_and_collide(
				Vector3(delta * _entity.speed, 0, 0)
			);
		"up":
			_is_colliding = _entity.move_and_collide(
				Vector3(0, 0, -delta * _entity.speed)
			);
		"down":
			_is_colliding = _entity.move_and_collide(
				Vector3(0, 0, delta * _entity.speed)
			);
	
	# метод родителя
	.process(delta);
	
# окончание действия
func end() -> void:
	# родитель
	.end();



