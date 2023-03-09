class_name CThread

# в процессе ли поток
var _is_processed: bool = false;

# правила сущности
var _rules: Array;

# сущность
var _entity: Object;

# номер потока
var _number: int;

# поднять объект
func _init(number: int, rules: Array, entity: Object) -> void:
	_rules	= rules;
	_number	= number;
	_entity	= entity;
	
	# листаем правила
	for _rule in rules:
		# делимся информацией о потоках с механизмом
		# действий
		_entity.actions.set_thread_action(_number, _rule.get_name());
	
# процесс потока
func process(delta: float) -> void:
	# если поток в процессе
	if true == _is_processed:
		print("CThread ERROR");
		
	# фиксируем запуск потока
	_is_processed = true;
	
	# записываем CActions сущности в отдельную переменную
	var _actions = _entity.actions;
	
	# активных действий НЕТ
	if false == _actions.has_current_action(_number):
		# листаем правила сущности
		for _rule in _rules:
			# есть ли ...
			if (
				# ... клавиша старта у правила
					_rule.is_start_key()
				# ... и нажата ли она
				&&	Input.is_action_pressed(_rule.get_start_key())
			):
				# запускаем действие
				_actions.set_current_action(_rule.get_name(), delta, _number);
				
				# запускаем процесс
				_actions.get_current_action(_number).process(delta);
	
	# если действие ЕСТЬ
	else:
		# получаем и листаем допустимые внутренние действия
		for _permissible in get_current_rule(
			_actions.get_current_action(_number).get_name()
		).get_allowed_actions():
			# если ...
			if (
				# ... у одного из них есть клавиша старта
					get_current_rule(_permissible).is_start_key()
				# ... и эта клавиша нажата
				&&	Input.is_action_pressed(
						get_current_rule(_permissible).get_start_key()
					)
			):
				# запускаем под действие
				_actions.set_current_action(_permissible, delta, _number);
		
		# запускаем процесс
		_actions.get_current_action(_number).process(delta);
	
	# мониторинг окончания действий
	# листаем все активные действия потока
	for _action in _actions.get_current_actions(_number):
		# если нет клавиши окончания
		if false == get_current_rule(_action.get_name()).is_end_key():
			# истек ли таймер
			if true == _action.is_timer_out():
				# завершаем действие
				_actions.end_action(_action.get_name());
		
		# если у действия ЕСТЬ клавиша окончания
		# и она нажата
		elif Input.is_action_just_released(
			get_current_rule(_action.get_name()).get_end_key()
		):
			# завершаем действие
			_actions.end_action(_action.get_name());
	
	# завершаем процесс
	_is_processed = false;

# метод возвращает текущий набор правил
func get_current_rules() -> Array:
	return _rules;

# есть ли правило у текущей сущности (по имени)
func is_current_rule(name: String) -> bool:
	return null != get_current_rule(name);

# получаем правило текущей сущности по имени
func get_current_rule(name: String) -> CControlRule:
	# листаем правила текущей сущности
	for _rule in get_current_rules():
		# если имена совпадают
		if _rule.get_name() == name:
			# возвращаем правило
			return _rule;
	
	# возвращаем null, если правила нет
	return null;

# получить номер потока
func get_number() -> int:
	return _number;
