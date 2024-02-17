extends CActionBase

class_name CActionsBonusBaseArmor

# инициализировать действие
func _init(name: String).(name) -> void:
	pass;
	
# первичный запуск действия
func run(_delta: float) -> void:
	# стартуем таймер
	start_timer(_entity.timer);
	
	# скрываем пробиваемую стену вокруг базы
	_entity.hide_red_wall();
		
	# листаем нпс
	for _npc in CApp.get_scene().get_enemies():
		# если нпс в зоне поражения
		if true == _npc.in_death_zone:
			# стартуем действие "уничтожить танк"
			_npc.actions.set_current_action("destroy", _delta);
			# шарим уничтожение нпс
			CApp.share(_npc, "share_destroy");
			
	# листаем игроков
	for _player in CApp.get_scene().get_players():
		# если игрок в зоне поражения
		if true == _player.in_death_zone:
			# сбрасываем хп
			_player.set_hp(1);
			# закрываем все действия
			_player.actions.end_all_actions();
			# стартуем действие "уничтожить танк"
			_player.actions.set_current_action("destroy", _delta);
			# шарим уничтожение игрока
			CApp.share(_player, "share_destroy");

	# отображаем не пробиваемую стену вокруг базы
	_entity.show_white_wall();
	
	# шарим активацию бонуса
	CApp.share(_entity, "share_activate");

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

	# скрываем не пробиваемую стену вокруг базы
	_entity.hide_white_wall();
	# отображаем пробиваемую стену вокруг базы
	_entity.show_red_wall();

	# шарим деактивацию бонуса
	CApp.share(_entity, "share_deactivate");

	# деактивируем бонус
	_entity.deactivate();

