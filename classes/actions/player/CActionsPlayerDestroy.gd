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
	_parts.set_name("Parts");
	# грузим на сцену
	_entity.add_child(_parts);
	
	# отключаю коллизию
	_entity.get_node("CollisionShape").disabled = true;
	# отключаю реакцию на мир
	_entity.set_collision_mask_bit(0, false);
	# уничтожаем модель танка
	_entity.get_node("Tank").queue_free();
	# запускаем скрипт разрушения
	_entity.get_node("Parts").destroy();

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
	_entity.get_node("Parts").free();
	
	# получаем точку респа
	var _respawn_point = CApp.grid.get_cell_by_type(
		CApp.grid._PLAYER_1 if _entity.number == 1 else CApp.grid._PLAYER_2
	).vector;
	# двигаю танк в ангар
	_respawn_point = _respawn_point + Vector3(0, 0, 2 * CApp.grid.get_cell_size().z)
	# устанавливаем стратовые координаты танка
	_entity.global_translation = _respawn_point;
	# уменьшаем кол-во жизней
	_entity.set_lives(_entity.lives - 1);
	# устанавиваем кол-во жизней в интерфейсе
	_entity.set_lives_in_ui();
	
	# если жизней более нуля
	if _entity.lives > 0:
		# старт действия "возродить"
		_entity.actions.set_current_action("respawn", _delta);
		
	else:
		print("game over");

