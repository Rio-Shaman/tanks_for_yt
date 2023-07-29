extends CActionBase

class_name CActionsBonusShip

# инициализировать действие
func _init(name: String).(name) -> void:
	pass;
	
# первичный запуск действия
func run(_delta: float) -> void:
	# устанавливаем флаг корабля игроку
	_entity.get_player().ship = true;
	
	# отображаем флаг
	_entity.get_player().get_node("Flag_Blue").visible = true;
	
	# если игрок 1
	if _entity.get_player().number == 1:
		# отключаем 7-ой бит (воду)
		_entity.get_player().set_collision_mask_bit(7, false);

# процесс действия
func process(delta: float) -> void:
	# метод родителя
	.process(delta);
	
	# если ...
	if(
		# ... спал эфект корабля
			false == _entity.get_player().ship
		# ... и игрок НЕ на воде
		&&	false == _entity.get_player().is_on_water()
	):
		# завершаем действия
		_entity.actions.end_action(get_name());

# окончание действия
func end() -> void:
	# метод родителя
	.end();
	
	# прячем флаг
	_entity.get_player().get_node("Flag_Blue").visible = false;
	
	# если игрок 1
	if _entity.get_player().number == 1:
		# отключаем 7-ой бит (воду)
		_entity.get_player().set_collision_mask_bit(7, true);
	
	# деактивируем бонус
	_entity.deactivate();

