extends CActionBase

class_name CActionsWindowOpen

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
	
	# если проект НЕ на паузе
	if false == CApp.is_paused():
		# ставим проект на паузу
		CApp.paused();
	
	# открываем окно
	_window.open();

	# если у окна есть метод "share_window"
	if _window.has_method("share_window"):
		# шарим
		CApp.share(_window, "share_window");
