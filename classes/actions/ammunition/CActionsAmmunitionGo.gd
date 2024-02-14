extends CActionBase

class_name CActionsAmmunitionGo

# время таймера
var _timer: float;

# текушее направление
var _vector: Vector3;

# дельта
var _delta: float;

# коллизия
var _is_colliding: KinematicCollision;

# инициализировать действие
func _init(name: String, timer: float).(name) -> void:
	# время таймера
	_timer = timer;
	
# первичный запуск действия
func run(delta: float) -> void:
	# текушее направление
	_vector = _entity.global_transform.basis.z;
	
	# стартуем таймер
	start_timer(_timer);
	
	# сохраняем дельту
	_delta = delta;
	
# процесс действия
func process(delta: float) -> void:
	
	# движение снаряда
	_is_colliding = _entity.move_and_collide(
		Vector3(
			delta * (_vector.x * -1) * _entity.speed,
			0,
			delta * (_vector.z * -1) * _entity.speed
		)
	);

	# метод родителя
	.process(delta);
	
	# если таймер истек или есть столкновение
	if is_timer_out() || null != _is_colliding:
		_entity.actions.end_action(get_name());
		
# окончание действия
func end() -> void:
	# метод родителя
	.end();
	
	# если 
	if (
		# ... есть коллизия
			null != _is_colliding
		# ... и в объекте есть метод "make_damage"
		&&	_is_colliding.collider.has_method("make_damage")
	):
		# запускаем метод
		_is_colliding.collider.make_damage(_entity.who, _delta);
		
	# шарим удаление
	CApp.share(_entity, "share_destroy");
	
	# удаляем снаряд
	_entity.queue_free();
