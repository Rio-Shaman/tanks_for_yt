class_name CAudio

# проигрыватель с кол-вом запусков
var _progress: Dictionary;

# список проигрывателей (объекты класса
# AudioStreamPlayer)
var _players: Dictionary;

# создаем плеер
func set_player(_name: String) -> void:
	# поднимаем проигрыватель
	var _asp = AudioStreamPlayer.new();
	
	# устанавливаем громкость
	_asp.set_volume_db(CApp.volume);

	# грузим файл
	var _stream = load(
		"res://assets/sounds/" + _name + ".mp3"
	);
	
	# назначаем файл в проигрыватель
	_asp.set_stream(_stream);
	
	# если аудио НЕ зацикленное
	if false == _stream.has_loop():
		# регаем сигнал на плеере
		_asp.connect("finished", self, "on_finished", [_name]);
	
	# сохраняем объект AudioStreamPlayer
	_players[_name] = _asp;
	
	# грузим проигрыватель на сцену
	CApp.get_scene().add_child(_asp);

# начинаем играть звук
func play(_name: String) -> void:
	# есть ли проигрыватель
	if false == _players.has(_name):
		# выходим из метода
		return;
	
	# если для проигрывателя нет прогресс бара
	if false == _progress.has(_name):
		# создаем его
		_progress[_name] = [];
	
	# если в прогресс баре пусто
	if true == _progress.get(_name).empty():
		# запускаем звук
		_players.get(_name).play();

	# если ...
	if (
		# ... прогресс бар пуст
			true == _progress.get(_name).empty()
		# ... или проигрыватель зациклен
		||	true == _players.get(_name).get_stream().has_loop()
	):
		# наполняем прогресс бар
		_progress.get(_name).append(1);

# остановить звук
func stop(_name: String) -> void:
	# есть ли проигрыватель
	if false == _players.has(_name):
		# выходим из метода
		return;

	# если для проигрывателя нет прогресс бара
	if false == _progress.has(_name):
		# создаем его
		_progress[_name] = [];
	
	# если в прогресс баре 1 элемент
	if _progress.get(_name).size() == 1:
		# останавливаем звук
		_players.get(_name).stop();

	# удаляем запуск из прогресс бара
	_progress.get(_name).pop_back();

# играет ли проигрыватель
func is_played(_name: String) -> bool:
	# если для проигрывателя нет прогресс бара
	if false == _progress.has(_name):
		# то точно звук не играет
		return false;

	# если в прогресс баре есть данные
	# то да, звук проигрывается
	return _progress.get(_name).size() > 0;

# сигнал автоматической остановки
# проигрывателя
func on_finished(_name: String) -> void:
	# удаляем запуск из прогресс бара
	_progress.get(_name).pop_back();

