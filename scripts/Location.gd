extends Spatial

# инициализация
func _init():
	# подгружаем первичные
	# данные сцены
	CApp.load_scene();

# узел готов
func _ready() -> void:
	# загружаем сетку
	CApp.grid.load_grid();
