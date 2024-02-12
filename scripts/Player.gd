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
func make_damage(_npc: KinematicBody, delta: float) -> void:
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
		actions.set_current_action("destroy", delta);
	
	# если есть еще хп
	else:
		# уменьшаем хп на ед.
		set_hp(hp - 1);
		# обновление танка
		update();

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
		# выходим из метода
		# return;
	
	# записываем кол-во жизней в бар
	CApp.get_scene().get_node(
		"Map/UI/Bar_" + String(number) + "/HBoxContainer/Lives"
	).set_text(
		String(lives)
	);
	
# сохраняем очки игрока
func save_score(entity: Node) -> void:
	# блок с числом
	var _score = load("res://assets/scenes/bonuses/Score.tscn").instance();
	# заполняем текст
	_score.get_node("Label").set_text(String(entity.score));
	# подставляем координаты
	_score.translation = Vector3(entity.translation.x, 0, entity.translation.z);
	
	# грузим на сцену
	CApp.get_scene().add_child(_score);
	
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

# шарим позицию игрока
func share_position(transform: Transform) -> void:
	# сохраняем позицию
	global_transform = transform;


