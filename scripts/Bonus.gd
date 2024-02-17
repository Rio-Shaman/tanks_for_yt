extends Area

class_name CBonus

# типы бонусов
enum {
	_UPGRADE = 0,
	_LIFE = 1,
	_TIME = 2,
	_DESTROY = 3,
	_BASE_ARMOR = 4,
	_SHIP = 5,
	_ARMOR = 6
};

# тип бонуса
var _type: int;

# механизм действий
var actions: CActions;

# игрок
var _player: KinematicBody;

# дельта
var _delta: float;

# кол-во очков
var score: int = 200;

# узел готов
func _ready():
	# поднимаем механизм действий
	actions = CActions.new(self);
	
	# триггер на коллизию с игроком
	var _error = connect("body_entered", self, "_on_body_entered");
	
# раз в кадр
func _physics_process(delta: float) -> void:
	# сохраянем дельту
	_delta = delta;
	
	# если есть центральное действие
	if actions.has_current_action():
		# исполняем его
		actions.get_current_action().process(_delta);
	
# активация бонуса
func activate() -> void:
	# отключаем коллизию
	get_node("CollisionShape").disabled = true;
	# делаем бонус не видимым
	visible = false;
	# накидываем очки за бонус
	_player.save_score(self);
	# шарим уведомление
	CApp.share_unreliable(self, "share_notice", _player.number);
	# шарим видимость
	CApp.share(self, "share_visible");
	
# деактивация бонуса
func deactivate() -> void:
	# шарим уничтожение
	CApp.share(self, "share_destroy");
	# удаляем бонус с сцены
	queue_free();

# установить тип бонуса
func set_type(type: int) -> void:
	_type = type;

# получить тип бонуса
func get_type() -> int:
	return _type;

# запомнить игрока
func set_player(player: KinematicBody) -> void:
	_player = player;

# получить игрока
func get_player() -> KinematicBody:
	return _player;

# получить аналогичный бонус
func _get_similar_bonus(_by_player: bool = true) -> Node:
	# листаем бонусы
	for _child in CApp.get_tree().get_nodes_in_group("Bonuses"):
		# если ...
		if (
			# ... НЕ текущий бонус
				_child != self
			# ... типы совпадают
			&&	_child.get_type() == get_type()
			# ... сопадает игрок
			&&	(false == _by_player || _child.get_player() == get_player())
		):
			# возвращаем узел
			return _child;
	
	return null;

# коллизия с игроком
func _on_body_entered(player: Node) -> void:
	# сохраняем игрока
	set_player(player);
	# активируем бонус
	activate();

# шарим удаление бонуса
func share_destroy() -> void:
	# удаляем бонус с сцены
	queue_free();

# шарим видимость
func share_visible() -> void:
	# делать бонус не видимым
	visible = false;
	# звук "бонус взят"

# шарим уведомление
func share_notice(_number: int) -> void:
	# листаем игроков
	for player in CApp.get_scene().get_players():
		# отыскиваем нужного
		if player.number == _number:
			# вызываем уведомление
			player.notice(self);


