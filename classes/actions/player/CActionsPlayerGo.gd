extends CActionBase

class_name CActionsPlayerGo

# направление
var _direction: String;

# дельта
var _delta: float;

# инициализировать действие
func _init(name: String, direction: String).(name) -> void:
	# запоминаем направление
	_direction = direction;
	
# первичное действие
func run(delta: float) -> void:
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
			
	# запоминаем дельту
	_delta = delta;
	
	# стратуем звук езды
	CApp.audio.play("engine");
	
	# шарим звук
	CApp.share(CApp, "share_audio_play", "engine");
	
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
	
	# шарим позицию игрока
	CApp.share_unreliable(
		_entity,
		"share_position",
		_entity.global_transform
	);
	
	# метод родителя
	.process(delta);

# окончание действия
func end() -> void:
	# родитель
	.end();
	
	# на льду ли игрок
	if true == _entity.is_on_ice():
		# стартуем скольжение
		_entity.actions.set_current_action("slip", _delta);
		# шарим скольжение
		CApp.share(_entity, "share_slip");
	# если игрок НЕ на льду
	else:
		# останвливаем звук езды
		CApp.audio.stop("engine");
		# шарим звук
		CApp.share(CApp, "share_audio_stop", "engine");



