extends CActionBase

class_name CActionsWallDestroy

# инициализировать действие
func _init(name: String).(name) -> void:
	pass;
	
# первичный запуск действия
func run(_delta: float) -> void:
	# стартуем задержку
	start_timer(1.5);
	
	# загружаем частицы
	var _parts = load("res://assets/scenes/particles/Bricks.tscn").instance();
	# отображаем
	_parts.visible = true;
	# даем конкретное имя
	_parts.set_name("Bricks");
	# грузим на сцену
	_entity.add_child(_parts);
	
	# отключаем коллизию
	_entity.get_node("CollisionShape").disabled = true;
	# прячем стену
	_entity.get_node("wall_1").visible = false;
	
	# запускаем скрипт разрушения
	_entity.get_node("Bricks").destroy();
	
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
	
	# удаляем стену с сцены
	_entity.queue_free();



