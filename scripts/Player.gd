extends KinematicBody

class_name CPlayerBase

# скорость танка
var speed: float = 5;

# хп игрока
var hp: int = 1;

# жизни игрока
var lives: int = 3;

# флаг первого кадра
var _first_frame: bool = true;

# в зоне смерти
var in_death_zone: bool = false;

# активен ли бонус "броня"
var armor: bool = false;

# активен ли бонус "корабль"
var ship: bool = false;

# номер игрока
var number: int;

# механизм действий
var actions: CActions;

# готов ли игрок
var _ready: bool = false;

# узел готов
func ready(_number: int) -> void:
	# записываем номер игрока
	number = _number;
	
	# назначаем хп
	set_hp(
		int(CApp.get_from_tmp("player" + String(number) + ".hp", "1"))
	);
	
	# назначаем жизней
	set_lives(
		int(CApp.get_from_tmp("player" + String(number) + ".lives", "3"))
	);
	
	# обновляем жизни в UI
	set_lives_in_ui();
	
	# прячем синий флга
	get_node("Flag_Blue").visible = false;
	# прячем красный флга
	get_node("Flag_Red").visible = false;
	
	# определяем танк в группу "Players"
	add_to_group("Players");
	
	# если НЕТ жизней
	if lives == 0:
		# отображаем плашку game over
		CApp.get_scene().get_node(
			"Map/GameOver" + String(number)
		).visible = true;
		
		# если игрок НЕ бот
		if false == is_bot():
			# врубаем заглушку
			CApp.control.set_current_entity("gameover_player");

# раз в кадр
func _physics_process(delta: float) -> void:
	# если первый кадр
	if true == _first_frame:
		# если жизней более нуля
		if lives > 0:
			# старт действия "возродить"
			actions.set_current_action("respawn", delta);
		
		# первый кадр отработал
		_first_frame = false;
		
		# обрываем работу _physics_process
		return;

	#  если и грок бот
	if true == is_bot():
		# если есть действие на исполнение
		if true == actions.has_current_action():
			# исполяем его руками
			actions.get_current_action().process(delta);

# нанести урон
func make_damage(_npc: KinematicBody, _delete: float) -> void:
	# если активна броня
	if true == armor:
		# домаг наносить нельзя
		# выходим из метода
		return;
		
	# если актиывен "корабль"
	if true == ship:
		# снимаем бонус
		ship = false;
		# выходим из метода
		return;
	
	# если у танка хп на один удар
	if hp == 1:
		# закрываеем все действия
		actions.end_all_actions();
		# стартуем действие "уничтожить танк"
		actions.set_current_action("destroy", CApp.get_delta());
		# шарим уничтожение танка
		CApp.share(self, "share_destroy");
	
	# если есть еще хп
	else:
		# уменьшаем хп на ед.
		set_hp(hp - 1);
		# обновление танка
		update();
		# шарим хп
		CApp.share(self, "share_hp", hp);

# установить для хп значение
func set_hp(value: int) -> void:
	# назначаю новое хп
	hp = value;
	# сохраняем в темп
	CApp.save_in_tmp("player" + String(number) + ".hp", String(hp));
	
# установить кол-во жизней
func set_lives(value: int) -> void:
	# назначаю новое значение
	lives = value;
	# пишем в темп
	CApp.save_in_tmp(
		"player" + String(number) + ".lives",
		String(lives)
	);

# обновление танка
func update() -> void:
	# если есть узел модели танка
	if true == has_node("Tank"):
		# удаляем модель танка
		get_node("Tank").free();
	
	# получаем новую модель танка
	var _tank = load(
		"res://assets/models/tanks/tank_" + String(number) + "_" + String(hp) + ".tscn"
	).instance();
	
	# скорость танка от типа
	speed = 6 if hp == 3 else 5;
	
	# даем конкретное имя узлу
	_tank.set_name("Tank");
	
	# грузим на сцену
	add_child(_tank);

# проверка, на льду ли танк
func is_on_ice() -> bool:
	# листаю детекторы
	for _child in get_node("IceDetectors").get_children():
		# если хотя 1 из детекторов наткнулся на лед
		if true == _child.is_colliding():
			# говорим что игрок на льду
			return true;
			
	# в остальных случаях игрок НЕ на льду
	return false;

# проверка, на воде ли танк
func is_on_water() -> bool:
	# листаю детекторы
	for _child in get_node("WaterDetectors").get_children():
		# если хотя 1 из детекторов наткнулся на воду
		if true == _child.is_colliding():
			# говорим что игрок на воде
			return true;
			
	# в остальных случаях игрок НЕ на воде
	return false;

# установить кол-во жизней в интерфейс
func set_lives_in_ui() -> void:
	# если второй игрок НЕ активен
	if false == CApp.is_online() && number == 2:
		# выходим из метода
		return;
	
	# записываем кол-во жизней в бар
	CApp.get_scene().get_node(
		"Map/UI/Bar_" + String(number) + "/HBoxContainer/Lives"
	).set_text(
		String(lives)
	);
	
# сохраняем очки игрока
func save_score(entity: Node) -> void:
	# уведомление о начислении очков
	notice(entity);
	
	# группа в темп
	var _group = "player" + String(number);
	# текущие очки игрока
	var _scores = {
		"npc_1": int(CApp.get_from_tmp(_group + ".score_1", "0")),
		"npc_2": int(CApp.get_from_tmp(_group + ".score_2", "0")),
		"npc_3": int(CApp.get_from_tmp(_group + ".score_3", "0")),
		"bonuses": int(CApp.get_from_tmp(_group + ".score_bonuses", "0")),
	};
	
	# по классу определяем, что перед нами ...
	match(entity.get_class()):
		# ... npc
		"KinematicBody":
			# сохраняем очки в группу playerN.score_Y
			CApp.save_in_tmp(
				_group + ".score_" + String(entity.type),
				String(_scores.get("npc_" + String(entity.type)) + entity.score)
			);
		
		# ... бонус
		"Area":
			# сохраняем очки в группу playerN.score_bonuses
			CApp.save_in_tmp(
				_group + ".score_bonuses",
				String(_scores.get("bonuses") + entity.score)
			);

# уведомление о начислении очков
func notice(entity: Node) -> void:
	# блок с числом
	var _score = load("res://assets/scenes/bonuses/Score.tscn").instance();
	# заполняем текст
	_score.get_node("Label").set_text(String(entity.score));
	# подставляем координаты
	_score.translation = Vector3(entity.translation.x, 0, entity.translation.z);

	# грузим на сцену
	CApp.get_scene().add_child(_score);

# подсчитываем очки игрока
func scoring(_win: Node) -> void:
	# имя узла игрока
	var _node = "Player_" + String(number);
	# группа в темп
	var _group = "player" + String(number);
	# текущий тотал игрока
	var _total = int(CApp.get_from_tmp(_group + ".score_total", "0"));

	# выводим очки в блок "бонусы"
	_win.get_node("BG/Total/Bonus/" + _node).set_text(
		CApp.get_from_tmp(_group + ".score_bonuses", "0")
	);
	
	# выводим очки в блок "NPC_N"
	for _n in ["1", "2", "3"]:
		_win.get_node("BG/Total/Statistics/" + _node + "/NPC_" + _n).set_text(
			CApp.get_from_tmp(_group + ".score_" + _n, "0")
		);
		
	# пересчитываем тотал игрока
	_total += (
		  int(CApp.get_from_tmp(_group + ".score_bonuses", "0"))
		+ int(CApp.get_from_tmp(_group + ".score_1", "0"))
		+ int(CApp.get_from_tmp(_group + ".score_2", "0"))
		+ int(CApp.get_from_tmp(_group + ".score_3", "0"))
	);
	
	# сохраняю тотал для прогресса
	CApp.save_in_tmp(_group + ".score_total", String(_total));

	# выводим очки в блок "тотал"
	_win.get_node("BG/Total/Statistics/" + _node + "/Total").set_text(
		CApp.get_from_tmp(_group + ".score_total", String(_total))
	);
	
	# удаляем из темп блоки "бонусы" и "npc_N"
	for _n in ["bonuses", "1", "2", "3"]:
		CApp.destroy_from_tmp(_group + ".score_" + _n);

# является ли игрок ботом
func is_bot(_n: int = -1) -> bool:
	# если игра оффлайн
	if false == CApp.is_online():
		# игрок точне НЕ бот
		return false;
		
	# если номер игрока еще НЕ определен
	# получаем напрямую из _n
	var _number = number if _n == -1 else _n;
	
	# если "мир" 1 и игрок (_number) равен 2
	if true == CApp.is_master() && _number == 2:
		# то игрок _number является ботом
		return true;
		
	# если "мир" 2 и игрок (_number) равен 1
	if false == CApp.is_master() && _number == 1:
		# то игрок _number является ботом
		return true;
	
	# в остальных случаях НЕ бот
	return false;

# готов ли игрок
func is_ready() -> bool:
	return _ready;

# отмечаемся как "готов"
func im_ready() -> void:
	# сообщаем что игрок готов
	_ready = true;
	# говорим другому "миру" что я готов
	_to_say_im_ready();

# сказать: "я готов"
func _to_say_im_ready() -> void:
	# шарим состояние
	CApp.share_unreliable(self, "share_im_ready");
	
	# создать таймер
	var _timer = get_tree().create_timer(0.5, false);
	# регаем сигнал исхода таймера
	_timer.connect("timeout", self, "_repeat_to_say_im_ready");

# поторяю: "я готов"
func _repeat_to_say_im_ready() -> void:
	# повторяем запуск "я готов"
	_to_say_im_ready();

# создаем снаряд
func create_shell() -> KinematicBody:
	# создаем снаряд
	var _shell = load(
		"res://assets/scenes/ammunition/Shell_Player.tscn"
	).instance();
	
	# настраиваем позицию снаряда
	_shell.global_transform = get_node("Gun").global_transform;

	# даем уникальное имя
	_shell.set_name("ShellFrom" + get_name());
	
	# сохраняем того кто стрелял
	_shell.who = self;
	
	# скорость снаряда
	_shell.speed = 15 if hp == 3 else 10;
	
	# возвращаем снаряд
	return _shell;

# шарим позицию игрока
func share_position(transform: Transform) -> void:
	# если игрок НЕ занят
	if false == actions.has_current_action():
		# сохраняем позицию
		global_transform = transform;

# шарим готовность игрока
func share_im_ready() -> void:
	_ready = true;

# шарим снаряд
func share_shell() -> void:
	# создаем снаряд
	var _shell = create_shell();
	
	# если снаряда с таким name НЕТ на локации
	if false == CApp.get_scene().has_node(_shell.get_name()):
		# создаем
		CApp.get_scene().add_child(_shell);
		# запускаем звук выстрела
		CApp.audio.play("shot");

# шарим уничтожение
func share_destroy() -> void:
	# устанавливаем стартовое хп
	set_hp(1);
	# закрываеем все действия
	actions.end_all_actions();
	# стартуем действие "уничтожить танк"
	actions.set_current_action("destroy", CApp.get_delta());

# шарим скольжение
func share_slip() -> void:
	# если игрок НЕ занят
	if false == actions.has_current_action():
		# стартуем скольжение
		actions.set_current_action("slip", CApp.get_delta());

# шарим жизни
func share_lives(value: int) -> void:
	# назначаем новое кол-во жизней
	set_lives(value);
	# перерисовываем UI
	set_lives_in_ui();

# шарим хп
func share_hp(value: int) -> void:
	# сохраняем новое кол-во хп
	set_hp(value);
	# обновляет тип танка
	update();

