extends CActionBase

class_name CActionsBonusArmor

# инициализировать действие
func _init(name: String).(name) -> void:
	pass;
	
# первичный запуск действия
func run(_delta: float) -> void:
	# стартуем таймер
	start_timer(_entity.timer);
	
	# устанавливаем неуезвимость игроку
	_entity.get_player().armor = true;
	
	# отображаем флаг
	_entity.get_player().get_node("Flag_Red").visible = true;
	
	# шарим флаг
	CApp.share(_entity, "share_flag", _entity.get_player().number, true);

# процесс действия
func process(delta: float) -> void:
	# метод родителя
	.process(delta);

	# если таймер истек
	if is_timer_out():
		# завершаем действия
		_entity.actions.end_action(get_name());

# окончание действия
func end() -> void:
	# метод родителя
	.end();

	# убираем неуезвимость игроку
	_entity.get_player().armor = false;

	# прячем флаг
	_entity.get_player().get_node("Flag_Red").visible = false;

	# шарим флаг
	CApp.share(_entity, "share_flag", _entity.get_player().number, false);

	# деактивируем бонус
	_entity.deactivate();
