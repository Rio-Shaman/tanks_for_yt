extends CActionBase

class_name CActionsNPCLoad

# инициализировать действие
func _init(name: String).(name) -> void:
	pass;
	
# первичное действие
func run(_delta: float) -> void:
	# стартуем задержку
	start_timer(0.5);
	
	# создаем нпс
	var _npc = _entity.create_enemy();
	
	# определяем бонусный ли нпс
	_npc.randomly_assign_bonus();
	
	# грузим танк на сцену
	CApp.get_scene().add_child(_npc);
	
	# шарим нпс
	CApp.share(_entity, "share_enemy", _npc.get_name(), _npc.get_bonus());

# процесс действия
func process(delta: float) -> void:
	# метод родителя
	.process(delta);

	# если таймер истек
	if is_timer_out():
		_entity.actions.end_action(get_name());

