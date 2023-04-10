extends KinematicBody

class_name CPlayerBase

# скорость танка
var speed: float = 5;

# хп игрока
var hp: int = 1;

# жизни игрока
var lives: int = 3;

# флаг первого кадра
var _first_frame: bool = true;

# механизм действий
var actions: CActions;

# узел готов
func ready() -> void:
	# назначаем хп
	set_hp(1);
	
	# назначаем жизней
	set_lives(3);

# раз в кадр
func _physics_process(delta: float) -> void:
	# если первый кадр
	if true == _first_frame:
		# если жизней более нуля
		if lives > 0:
			# старт действия "возродить"
			actions.set_current_action("respawn", delta);
		
		# первый кадр отработал
		_first_frame = false;

# нанести урон
func make_damage(delta: float) -> void:
	# если у танка хп на один удар
	if hp == 1:
		# закрываеем все действия
		actions.end_all_actions();
		# стартуем действие "уничтожить танк"
		actions.set_current_action("destroy", delta);
	
	# если есть еще хп
	else:
		# уменьшаем хп на ед.
		set_hp(hp - 1);
		# обновление танка
		update();

# установить для хп значение
func set_hp(value: int) -> void:
	# назначаю новое хп
	hp = value;
	
# установить кол-во жизней
func set_lives(value: int) -> void:
	# назначаю новое значение
	lives = value;

# обновление танка
func update() -> void:
	# если есть узел модели танка
	if true == has_node("Tank"):
		# удаляем модель танка
		get_node("Tank").free();
	
	# получаем новую модель танка
	var _tank = load(
		"res://assets/models/tanks/tank_1_" + String(hp) + ".tscn"
	).instance();
	
	# даем конкретное имя узлу
	_tank.set_name("Tank");
	
	# грузим на сцену
	add_child(_tank);

# проверка, на льду ли танк
func is_on_ice() -> bool:
	# листаю детекторы
	for _child in get_node("IceDetectors").get_children():
		# если хотя 1 из детекторов наткнулся на лед
		if true == _child.is_colliding():
			# говорим что игрок на льду
			return true;
			
	# в остальных случаях игрок НЕ на льду
	return false;
