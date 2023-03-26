extends KinematicBody

# механизм действий
var actions: CActions;

# скорость передвижения
var speed: float = 10;

# узел готов
func _ready() -> void:
	# поднимаем механизм действий
	actions = CActions.new(self);
	
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
