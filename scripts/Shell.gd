extends KinematicBody

# механизм действий
var actions: CActions;

# скорость передвижения
var speed: float = 10;

# кто стрелял
var who = KinematicBody;

# узел готов
func _ready() -> void:
	# поднимаем механизм действий
	actions = CActions.new(self);
	
	# если игра явялется "мир" 2
	if false == CApp.is_master():
		# листаем биты от 0 до 5
		for _bit in 6:
			# отключаем коллизию
			set_collision_mask_bit(_bit, false);
	
	# регаем возможные действия
	actions.set_action(CActionsAmmunitionGo.new("bullet_flight", 3));
	
# процесс работы приложения
func _physics_process(delta: float) -> void:
	# если нет действий
	if false == actions.has_current_action():
		# стартуем
		actions.set_current_action("bullet_flight", delta);
		
	# продолжаем пройцесс действия
	actions.get_current_action().process(delta);

# шарим уничтожение снаряда
func share_destroy() -> void:
	# удаляем ноду
	queue_free();

