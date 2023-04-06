extends CActionBase

class_name CActionsPlayerDestroy

# инициализировать действие
func _init(name: String).(name) -> void:
	pass
	
# первичное действие
func run(_delta: float) -> void:
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
	
	#




