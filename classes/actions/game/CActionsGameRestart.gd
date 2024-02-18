extends CActionBase

class_name CActionsGameRestart

# инициализировать действие
func _init(name: String).(name) -> void:
	pass

# окончание действия
func end() -> void:
	# метод родителя
	.end();
	
	# если игра онлайн
	if true == CApp.is_online():
		# закрываем соединение
		CApp.get_tree().get_network_peer().close_connection();
		# удалить объект мультиплеера
		CApp.get_tree().set_network_peer(null);
	
	# сбрасываем буфер
	CApp.tmp.clear_buffer();
	
	# принудительно сбрасываем кто есть сервер
	CApp.set_server(false);

	# начальный экран
	CApp.change_scene("res://assets/scenes/locations/MainMenu.tscn");
