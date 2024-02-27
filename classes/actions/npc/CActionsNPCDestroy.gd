extends CActionBase

class_name CActionsNPCDestroy

# инициализировать действие
func _init(name: String).(name) -> void:
	pass
	
# первичное действие
func run(_delta: float) -> void:
	# стартуем таймер
	start_timer(1.5);

	# если ...
	if (
		# ... есть действие
			true == _entity.actions.has_current_action(0)
		# .... и это действие "ездить"
		&&	_entity.actions.get_current_action(0).get_name() == "go"
	):
		# получаем пути с которым работает действие
		var _path = _entity.actions.get_current_action(0).get_path();
		
		# снимаем временный блок
		for i in _path.size():
			# снимаем блок с точки
			CApp.grid.get_astar().set_point_disabled(
				CApp.grid.get_cell_by_position(_path[i]).id,
				false
			);
	
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
	# прячу модель танка
	_entity.get_node("Tank").visible = false;
	# прячем флаг
	_entity.get_node("Flag").visible = false;
	# запускаем скрипт разрушения
	_entity.get_node("Parts").destroy();
	
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
	
	# удаляем НПС с сцены
	_entity.queue_free();




