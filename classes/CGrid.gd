class_name CGrid

# объект AStar
var _astar: AStar;

# размер сетки
var _grid_size: Dictionary = {
	"x": 13,
	"z": 13
};

# сетка на карте
# с информацией
var _grid: Array;

# типы точек на сетке
enum {
	_EMPTY = -1,
	_POINT = 0,
	_RESPAWN = 1,
	_BASE = 2,
	_PLAYER_1 = 3,
	_PLAYER_2 = 4,
	_BONUS = 5,
};

# загрузка сетки
func load_grid() -> void:
	# формируем сетку
	_get_grid();
	
	# формируем инфу для AStar
	_get_astar();

# получить сетку
func _get_grid() -> void:
	# карта
	var _map = CApp.get_scene().get_node("Map/GridMap");
	# стартовая точка (верхний левый угол)
	var _start: Vector3 = CApp.get_scene().get_node("Map/Start").global_translation;
	# колонки
	var _cols: Array = [];
	# строки
	var _rows: Array = [];
	# вектор клетки в сетке
	var _vector: Vector3;
	# id для переноса в AStar
	var _id = 1;
	
	# листаем до тех пор, пока
	# в массиве _rows меньше клеток
	# чем высота сетки
	while _rows.size() < _grid_size.z:
		# собираем колонки строки
		_cols = [];
		# листаем до тех пор, пока
		# в массиве _cols меньше клеток
		# чем ширина сетки
		while _cols.size() < _grid_size.x:
			# расчитываем координаты клетки в сетке
			# смещение от верхнего левого угла
			# на кол-во колонок/строк помноженного
			# на размер ячейки секти
			_vector = _start + Vector3(
				_cols.size() * _map.cell_size.x,
				0,
				_rows.size() * _map.cell_size.z
			);
			
			# заполняем колонку
			_cols.append({
				# id для AStar
				"id": _id,
				# тип точки на карте
				"type": _map.get_cell_item(
					int(_map.world_to_map(_vector).x),
					int(_map.world_to_map(_vector).y),
					int(_map.world_to_map(_vector).z)
				),
				# координаты клетки
				"vector": _vector,
				# номер строки
				"row": _rows.size(),
				# номер колонки
				"col": _cols.size()
			});
			
			# переключаем id для AStar
			_id += 1;
			
		# запоминаем колонку в строке
		_rows.append(_cols);
	
	# сохраняем собранную сетку
	_grid = _rows;
	
	# скрываем карту
	_map.visible = false;
	
# формируем AStar
func _get_astar() -> void:
	# поднимаем AStar
	_astar = AStar.new();

	# добавляем точки в AStar
	# листаем колонки
	for _col in _grid_size.x:
		# листаем строки в колонке
		for _row in _grid_size.z:
			# если клетка доступна
			if (
					_grid[_row][_col].type != _EMPTY
				&&	_grid[_row][_col].type != _PLAYER_1
				&&	_grid[_row][_col].type != _PLAYER_2
			):
				# регаем точку
				_astar.add_point(
					_grid[_row][_col].id,
					_grid[_row][_col].vector
				);

	# соединяем
	# листаем колонки
	for _col in _grid_size.x:
		# листаем строки в колонке
		for _row in _grid_size.z:
			# зарегана ли клетка
			if false == _astar.has_point(_grid[_row][_col].id):
				# если НЕТ, пропускаем итерацию
				continue;
				
			# если НЕ последняя колонка и клетка слева
			# зарегана
			if (
					_col != _grid_size.x - 1
				&&	true == _astar.has_point(_grid[_row][_col + 1].id)
			):
				# соединяем клетки
				_astar.connect_points(
					_grid[_row][_col].id,
					_grid[_row][_col + 1].id
				);
				
			# если НЕ последняя строка и клетка снизу
			# зарегана
			if (
					_row != _grid_size.z - 1
				&&	true == _astar.has_point(_grid[_row + 1][_col].id)
			):
				# соединяем клетки
				_astar.connect_points(
					_grid[_row][_col].id,
					_grid[_row + 1][_col].id
				);

# получить _grid_size
func get_grid_size() -> Dictionary:
	return _grid_size;

# получить _grid
func get_grid() -> Array:
	return _grid;

# получить AStar
func get_astar() -> AStar:
	return _astar;

# существует ли клетка в AStar
func has_cell_by_position(_position: Vector3) -> bool:
	return false == get_cell_by_position(_position).empty();

# получаем клетку по координатам
func get_cell_by_position(_position: Vector3) -> Dictionary:
	# листаем строки
	for _row in _grid.size():
		# листаем колонки
		for _col in _grid[_row].size():
			# проверяем дистанцию
			if _position.distance_to(_grid[_row][_col].vector) == 0:
				# есть ли данная точка в astar
				if _astar.has_point(_grid[_row][_col].id):
					# отдаем информацию о ячейке
					return _grid[_row][_col];
	
	return {};

# получаем клетку по типу
func get_cell_by_type(type: int, _slice: int = 1) -> Dictionary:
	# коллекция найденых клеток
	var _collect: Array = [];
	
	# листаем строки
	for _row in _grid.size():
		# листаем колонки строки
		for _col in _grid[_row].size():
			# если нужный тип
			if _grid[_row][_col].type == type:
				# сохраняем в коллекцию
				_collect.append(
					_grid[_row][_col]
				);
	
	# возвращаем нужную клетку из массива найденных клеток
	return _collect[_slice - 1] if _collect.size() > 0 else {};




