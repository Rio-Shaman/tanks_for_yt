class_name CTmp

# буфер
var _buffer: Dictionary;

# получить информацию из буфера
func get_value(path: String, default: String) -> String:
	# группа
	var group = path.split(".")[0];
	# параметр
	var param = path.split(".")[1];
	
	# если нет группы
	if false == _buffer.has(group):
		return default;
		
	# если нет параметра
	if false == _buffer[group].has(param):
		return default;

	return _buffer.get(group).get(param);

# добавить информацию в буфе
func set_value(path: String, value: String) -> void:
	# группа
	var group = path.split(".")[0];
	# параметр
	var param = path.split(".")[1];
	
	# если нет группы
	if false == _buffer.has(group):
		# создаем
		_buffer[group] = {};

	# запоминаем новое значение
	_buffer[group][param] = value;
		
# удалить информацию из буфера
func destroy_value(path: String) -> void:
	# группа
	var group = path.split(".")[0];
	# параметр
	var param = path.split(".")[1];
	
	# если нет группы
	if false == _buffer.has(group):
		return;
		
	# если нет значения
	if false == _buffer[group].has(param):
		return;

	# удаляем его
	_buffer[group].erase(param);

# почистить буфер
func clear_buffer() -> void:
	# полностью сбрасываем буфер
	_buffer = {};
