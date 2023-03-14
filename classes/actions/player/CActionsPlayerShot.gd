extends CActionBase

class_name CActionsPlayerShot

# снаряд
var _shell: KinematicBody;

# валидный ли снараяд
var _valid: bool = false;

# инициализировать действие
func _init(name: String).(name) -> void:
	pass
	
# первичное действие
func run(_delta: float) -> void:
	
	# стартуем задержку
	start_timer(10);
	
	# создаем снаряд
	_shell = load(
		"res://assets/scenes/ammunition/Shell_Player.tscn"
	).instance();
	
	# настраиваем позицию снаряда
	_shell.global_transform = _entity.get_node("Gun").global_transform;
	
	# снаряд полетел
	_valid = true;
	
	# добавляем снаряд на сцену
	CApp.get_scene().add_child(_shell);

# процесс действия
func process(delta: float) -> void:
	# метод родителя
	.process(delta);

	# если снаряд валиден, но исчез с сцены
	if true == _valid && false == is_instance_valid(_shell):
		# уменьшаем задержку перед повторным выстрелом
		start_timer(0.2);
		
		# и считаем снаряд НЕ валидным
		_valid = false;


