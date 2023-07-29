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
	CApp.get_scene().get_node("Map/Base/Unarmored").visible = false;
	# у блоков стены
	for _wall in CApp.get_scene().get_node("Map/Base/Unarmored").get_children():
		# отключаем колизию
		_wall.set_collision_layer_bit(0, false);
		
	# листаем нпс
	for _npc in CApp.get_scene().get_enemies():
		# если нпс в зоне поражения
		if true == _npc.in_death_zone:
			# стартуем действие "уничтожить танк"
			_npc.actions.set_current_action("destroy", _delta);
			
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

	# отображаем не пробиваемую стену вокруг базы
	CApp.get_scene().get_node("Map/Base/Armored").visible = true;
	# у блоков стены
	for _wall in CApp.get_scene().get_node("Map/Base/Armored").get_children():
		# активируем колизию
		_wall.set_collision_layer_bit(0, true);

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
	CApp.get_scene().get_node("Map/Base/Armored").visible = false;
	# у блоков стены
	for _wall in CApp.get_scene().get_node("Map/Base/Armored").get_children():
		# отключаем колизию
		_wall.set_collision_layer_bit(0, false);

	# отображаем пробиваемую стену вокруг базы
	CApp.get_scene().get_node("Map/Base/Unarmored").visible = true;
	# у блоков стены
	for _wall in CApp.get_scene().get_node("Map/Base/Unarmored").get_children():
		# включаем колизию
		_wall.set_collision_layer_bit(0, true);

	# деактивируем бонус
	_entity.deactivate();

