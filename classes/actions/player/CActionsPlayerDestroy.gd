extends CActionBase

class_name CActionsPlayerDestroy

# дельта
var _delta: float;

# инициализировать действие
func _init(name: String).(name) -> void:
	pass
	
# первичное действие
func run(delta: float) -> void:
	# сохраняем дельту
	_delta = delta;

	# стартуем таймер
	start_timer(1.5);
	
	# загружаем частицы
	var _parts = load("res://assets/scenes/particles/Parts.tscn").instance();
	# отображаем
	_parts.visible = true;
	# даем конкретное имя
	_parts.set_name("Parts" + _entity.get_name());
	# назанчаем координаты игрока
	_parts.global_transform = _entity.global_transform;
	# грузим на сцену
	CApp.get_scene().add_child(_parts);
	
	# отключаю коллизию
	_entity.get_node("CollisionShape").disabled = true;
	# отключаю реакцию на мир
	_entity.set_collision_mask_bit(0, false);
	# уничтожаем модель танка
	_entity.get_node("Tank").queue_free(); 

	# получаем точку респа
	var _respawn_point = CApp.grid.get_cell_by_type(
		CApp.grid._PLAYER_1 if _entity.number == 1 else CApp.grid._PLAYER_2
	).vector;
	# устанавливаем стратовые координаты танка
	_entity.global_translation = (
		_respawn_point + Vector3(0, 0, 2 * CApp.grid.get_cell_size().z)
	);

	# запускаем скрипт разрушения
	_parts.destroy();
	
	# останавливаем звук
	CApp.audio.stop("engine");
	# стратуем звук
	CApp.audio.play("explosion");

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
	
	# удаляем частицы с сцены
	CApp.get_scene().get_node(
		"Parts" + _entity.get_name()
	).free();
	
	# уменьшаем кол-во жизней
	_entity.set_lives(_entity.lives - 1);
	# устанавиваем кол-во жизней в интерфейсе
	_entity.set_lives_in_ui();
	
	# если жизней более нуля
	if _entity.lives > 0:
		# старт действия "возродить"
		_entity.actions.set_current_action("respawn", _delta);
		
	else:
		# отображаем плашку game over для игрока
		CApp.get_scene().get_node(
			"Map/GameOver" + String(_entity.number)
		).visible = true;
		
		# если игрок НЕ бот
		if false == _entity.is_bot():
			# переключаем сущность
			CApp.control.set_current_entity("gameover_player");

