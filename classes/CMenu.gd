class_name CMenu

# сущность
var _entity: Object;

# пункты меню
var _points: Array = [];

# инициализация
func _init(entity: Object, name: String) -> void:
	# сохраняем сущность
	_entity = entity;
	
	# поднимаем механизм
	_entity.actions = CActions.new(_entity);
	
	# регаем возможные действия
	# листаем вверх
	_entity.actions.set_action(CActionsMenuGo.new("up", "up"));
	# листаем вниз
	_entity.actions.set_action(CActionsMenuGo.new("down", "down"));
	# выбор пункта
	_entity.actions.set_action(CActionsMenuSelect.new("select"));

	# регаем менюху в контроллере
	CApp.control_1.set_entity(name, _entity, [
		[
			CControlRule.new("up", "ui_player_1_up", "ui_player_1_up"),
			CControlRule.new("down", "ui_player_1_down", "ui_player_1_down"),
			CControlRule.new("select", "ui_accept", "ui_accept")
		]
	], true);
	
	# собираем пункты
	var _index: int = 0;
	# листаем дочернии узлы
	for _button in _entity.get_children():
		# сохраняем в массив
		_points.append({
			# индекс
			"index": _index,
			# по умолчанию пункт НЕ активен
			"active": false,
			# узел с кнопкой
			"button": _button,
		});
		
		# переключаем индекс
		_index += 1;
	
	# деактивирую все кнопки
	_deactivate();
	
	# активирую первую кнопку
	activate(_points[0].button);

# получить следующую кнопку относительно button
func get_next(button: Node) -> Node:
	# получаем пункт
	var _point = _get_point(button);
	
	# если пункт всего 1
	if _points.size() == 1:
		# возвращаем самого себя
		return _point.button;
	
	# если последний индекс
	if (_points.size() - 1) == _point.index:
		# возвращаем индекс 0
		return _points[0].button;
	
	# в противном случае возвращаем след пункт
	return _points[_point.index + 1].button;

# получить предыдущую кнопку относительно button
func get_previous(button: Node) -> Node:
	# получаем пункт
	var _point = _get_point(button);

	# если пункт всего 1
	if _points.size() == 1:
		# возвращаем самого себя
		return _point.button;

	# если первый индекс
	if _point.index == 0:
		# возвращаем последний элемент
		return _points.back().button;
	
	# в противном случае возвращаем пред пункт
	return _points[_point.index - 1].button;

# получить выбраную кнопку
func get_current_button() -> Node:
	# листаем пункты
	for _point in _points:
		# если пункт активен
		if true == _point.active:
			# вертаем его
			return _point.button;
	
	# если кнопку не нашли, то *опа
	return null;
	
# активировать кнопку
func activate(button: Node) -> void:
	# получаем пункт
	var _point = _get_point(button);
	
	# меняем активность
	_point.active = true;
	
	# запускаем алгоритм активации
	_point.button.activate();

# деактивировать кнопку
func deactivate(button: Node) -> void:
	# получаем пункт
	var _point = _get_point(button);
	
	# меняем активность
	_point.active = false;
	
	# запускаем алгоритм активации
	_point.button.deactivate();

# обработчик кнопки
func select() -> void:
	# запускаем алгоритм выбора у активной кнопки
	get_current_button().select();
	
# получить кнопку
func _get_point(button: Node) -> Dictionary:
	# листаем пункты
	for _point in _points:
		# если кнопки совпадают
		if _point.button == button:
			# возвращаем словарь
			return _point;
	
	# в противном случае возвращаем пустой словарь
	# но это НЕ должно произойти
	return {};

# деактивировать все кнопки
func _deactivate() -> void:
	# листаем все кнопки
	for _point in _points:
		# сбрасываем активность пункта
		_point.active = false;
		# запускаем алгоритм деактивации
		_point.button.deactivate();


