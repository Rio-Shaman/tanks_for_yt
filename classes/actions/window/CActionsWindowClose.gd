extends CActionBase

class_name CActionsWindowClose

# окно
var _window: Node;

# инициализировать действие
func _init(name: String, window: Node).(name) -> void:
	# сохраняем окно
	_window = window;
	
# окончание действия
func end() -> void:
	# метод родителя
	.end();
	
	# если проект НА паузе
	if true == CApp.is_paused():
		# снимаем проект с паузы
		CApp.paused();
	
	# закрыть окно
	_window.close();

	# если у окна есть метод "share_window"
	if _window.has_method("share_window"):
		# шарим
		CApp.share(_window, "share_window");
