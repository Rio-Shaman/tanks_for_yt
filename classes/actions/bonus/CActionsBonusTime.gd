extends CActionBase

class_name CActionsBonusTime

# инициализировать действие
func _init(name: String).(name) -> void:
	pass;
	
# первичный запуск действия
func run(_delta: float) -> void:
	# стартуем таймер
	start_timer(_entity.timer);

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

	# деактивируем бонус
	_entity.deactivate();
