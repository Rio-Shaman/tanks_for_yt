extends KinematicBody

# скорость танка
var speed: float = 3;

# хп НПС
var hp: int = 1;

# механизм действий
var actions: CActions;

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
	
	# регаем действие "ездить" в потоке ноль
	actions.set_thread_action(0, "go");
	
	# регаем действие "стрелять" в потоке один
	actions.set_thread_action(1, "shot");

# раз в кадр
func _physics_process(delta: float) -> void:

	# если есть ВНЕ потоковое действие
	if true == actions.has_current_action():
		# исполняем его
		actions.get_current_action().process(delta);
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
func make_damage(delta: float) -> void:
	# если у танка хп на один удар
	if hp == 1:
		# стартуем действие "уничтожить танк"
		actions.set_current_action("destroy", delta);
	
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



