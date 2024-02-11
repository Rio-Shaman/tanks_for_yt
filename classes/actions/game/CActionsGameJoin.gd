extends CActionBase

class_name CActionsGameJoin

# шаблон IP
var _pattern: String = "^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$";

# инициализировать действие
func _init(name: String).(name) -> void:
	pass

# первичный запуск действия
func run(_delta: float) -> void:
	# ипут ввода
	var _input = _entity.get_node("LineEdit");
	# окно подключения
	var _connect = CApp.get_scene().get_node("Control/ColorRect/Connect");
	
	# введен ли ip
	if true == CApp.regex(_input.get_text(), _pattern):
		# объект рабоы с мультиплеером
		var _client = NetworkedMultiplayerENet.new();
		# подключаемся к серверу
		_client.create_client(_input.get_text(), CApp.get_port());
		# подписываемся на сигнал "пошел в жопу"
		_client.connect("connection_failed", _connect, "_connection_failed");
		# подписываемся на сигнал "все ок"
		_client.connect("peer_connected", _connect, "_connected");
		
		# фиксируем клиента в SceneTree
		CApp.get_tree().set_network_peer(_client);
		
		# прячем окно IP
		_entity.visible = false;
		# прячем окно "подключение"
		_connect.visible = true;

# окончание действия
func end() -> void:
	# метод родителя
	.end();

	# введен ли ip
	if true == CApp.regex(_entity.get_node("LineEdit").get_text(), _pattern):
		# устанавливаем сущность для контрола
		CApp.control.set_current_entity("connect");


