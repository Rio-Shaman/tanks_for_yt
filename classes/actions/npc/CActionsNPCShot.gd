extends CActionBase

class_name CActionsNPCShot

# снаряд
var _shell: KinematicBody;

# валидный ли снараяд
var _valid: bool = false;

# инициализировать действие
func _init(name: String).(name) -> void:
	pass;
	
# первичное действие
func run(_delta: float) -> void:
	# стартуем задержку
	start_timer(10);
	
	# создаем снаряд
	_shell = _entity.create_shell();
	
	# снаряд полетел
	_valid = true;
	
	# добавляем снаряд на сцену
	CApp.get_scene().add_child(_shell);
	
	# шарим снаряд
	CApp.share(_entity, "share_shell");

# процесс действия
func process(delta: float) -> void:
	# если у игроков взят бонус "время"
	if null != CApp.get_scene().get_active_bonus_by_type(CBonus._TIME):
		# выходим из процесса
		return;
	
	# метод родителя
	.process(delta);

	# если снаряд валиден, но исчез с сцены
	if true == _valid && false == is_instance_valid(_shell):
		# уменьшаем задержку перед повторным выстрелом
		start_timer(0.5);
		
		# и считаем снаряд НЕ валидным
		_valid = false;

	# если таймер истек
	if is_timer_out():
		_entity.actions.end_action(get_name());

