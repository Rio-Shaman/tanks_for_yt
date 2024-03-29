extends KinematicBody

# скорость танка
var speed: float = 3;

# хп НПС
var hp: int = 1;

# тип танка
var type: int = 1;

# механизм действий
var actions: CActions;

# точка респа
var respawn_point: Vector3;

# флаг первого кадра
var _first_frame: bool = true;

# в зоне смерти
var in_death_zone: bool = false;

# бонусный ли танк
var _is_bonus: bool;

# кол-во очков за уничтожение
var score: int;

# узел готов
func _ready() -> void:
	# поднимаем механизм действий
	actions = CActions.new(self);
	
	# регаем действие "стрелять"
	actions.set_action(CActionsNPCShot.new("shot"));
	# регаем действие "ездить"
	actions.set_action(CActionsNPCGo.new("go"));
	# регаю дейстиве "уничтожить"
	actions.set_action(CActionsNPCDestroy.new("destroy"));
	# регаем дейстиве "возродить"
	actions.set_action(CActionsNPCRespawn.new("respawn"));
	
	# регаем действие "ездить" в потоке ноль
	actions.set_thread_action(0, "go");
	# регаем действие "возродить" в потоке ноль
	actions.set_thread_action(0, "respawn");
	
	# регаем действие "стрелять" в потоке один
	actions.set_thread_action(1, "shot");

# раз в кадр
func _physics_process(delta: float) -> void:
	# если первый кадр
	if true == _first_frame:
		# старт действия "возродить"
		actions.set_current_action("respawn", delta, 0);
		# запускаем процесс
		actions.get_current_action(0).process(delta);
		
		# первый кадр отработал
		_first_frame = false;
		
		# завершаем процесс
		return;
	
	# если есть ВНЕ потоковое действие
	if true == actions.has_current_action():
		# исполняем его
		actions.get_current_action().process(delta);
		# обрываем _physics_process
		return;
	
	# если НЕ сервер
	if false == CApp.is_master():
		# если есть действие 0-ого потока
		if true == actions.has_current_action(0):
			# исполняем его
			actions.get_current_action(0).process(delta);
		
		# обрываем _physics_process
		return;
	
	# если нет активных действия на нулевом потоке
	if false == actions.has_current_action(0):
		# стартуем действие езды
		actions.set_current_action("go", delta, 0);
		# запускаем процесс
		actions.get_current_action(0).process(delta);
		
	# если есть действие в потоке ноль
	else:
		# процесс нулевого потока
		actions.get_current_action(0).process(delta);

		# если нет активных действия на первом потоке
		if !actions.has_current_action(1):
			# стартуем действие стрельбы
			actions.set_current_action("shot", delta, 1);
		# если есть активное действие
		else:
			# выполняем его
			actions.get_current_action(1).process(delta);

# нанести урон
func make_damage(player: KinematicBody, _delete: float) -> void:
	# если танк бонусный
	if true == _is_bonus:
		# генерируем бонус
		CApp.get_scene().generate_bonus();
	
	# если у танка хп на один удар
	if hp == 1:
		# накидываем очки за унчистожение NPC
		player.save_score(self);
		# стартуем действие "уничтожить танк"
		actions.set_current_action("destroy", CApp.get_delta());
		# шарим очки
		CApp.share(self, "share_score", player.number);
		# шарим уничтожение танка
		CApp.share(self, "share_destroy");
	
	# если есть еще хп
	else:
		# уменьшаем на один пункт
		hp -= 1;

# полчаем следующую клетку относительно
# текущих координат
func where_we_go() -> Dictionary:
	# если понятно где НПС
	if true == CApp.grid.has_cell_by_position(global_translation):
		# получаем его ячйку
		var _from = CApp.grid.get_cell_by_position(global_translation);
		# строка новой точки
		var _row: int;
		# колонка новой точки
		var _col: int;

		# расчитываем строку
		# если смещать некуда
		if _from.row + 2 >= CApp.grid.get_grid_size().z:
			# берем путь к базе
			return CApp.grid.get_cell_by_type(CApp.grid._BASE);
			
		# если есть куда смещать строку
		else:
			# смещаем
			_row = _from.row + 2;

			# бесконечный цикл
			while true:
				# выбераем рандомную колонку
				# от нуля до _grid_size.x
				_col = randi() % CApp.grid.get_grid_size().x;

				# если клетка зарегана
				if CApp.grid.get_astar().has_point(CApp.grid.get_grid()[_row][_col].id):
					# возвращаем информацию о клетке
					return CApp.grid.get_grid()[_row][_col];

	return {};

# рандомно назанить бонусность танка
func randomly_assign_bonus() -> void:
	# шанс того что танк будет бонусный 25%
	# устанавливакм флаг _is_bonus
	set_bonus(
		randi() % 100 < 25
	);

# получить флаг _is_bonus
func get_bonus() -> bool:
	return _is_bonus;

# фиксируем бонусный ли танк
func set_bonus(_value: bool) -> void:
	# прячем или отображаем желтый флаг
	get_node("Flag").visible = _value;
	
	# сохраняем значение
	_is_bonus = _value;

# создаем снаряд
func create_shell() -> KinematicBody:
	# создаем снаряд
	var _shell = load(
		"res://assets/scenes/ammunition/Shell_NPC.tscn"
	).instance();
	
	# настраиваем позицию снаряда
	_shell.global_transform = get_node("Gun").global_transform;

	# даем уникальное имя
	_shell.set_name("ShellFrom" + get_name());
	
	# сохраняем того кто стрелял
	_shell.who = self;

	# возвращаем снаряд
	return _shell;

# шарим уничтожение
func share_destroy() -> void:
	# стартуем действие "уничтожить танк"
	actions.set_current_action("destroy", CApp.get_delta());

func share_shell() -> void:
	# создаем и добавляем снаряд на сцену
	CApp.get_scene().add_child(
		create_shell()
	);

# шарим позицию НПС
func share_position(transform: Transform) -> void:
	# сохраняем позицию
	global_transform = transform;

# шарим уведомление
func share_score(_number: int) -> void:
	# листаем игроков
	for player in CApp.get_scene().get_players():
		# отыскиваем нужного
		if player.number == _number:
			# вызываем пересчет очков
			player.save_score(self);

