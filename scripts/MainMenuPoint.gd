extends CPoint

class_name MainMenuPoint

# деактивировать кнопку
func deactivate() -> void:
	# прячем курсор
	set("custom_colors/font_color", Color(1,1,1,0.5));
	
	# метод родителя
	.deactivate();

# активировать кнопку
func activate() -> void:
	# отображаем курсор
	set("custom_colors/font_color", Color(1,1,1,1));

	# метод родителя
	.activate();
