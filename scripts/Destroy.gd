extends Spatial

# эффект разрушения
func destroy() -> void:
	
	# листаем части
	for _part in get_children():
		# включаем обработку
		_part.set_mode(_part.MODE_RIGID);
		
		# настраиваем разброс частей
		_part.linear_velocity.y = 5;
		_part.linear_velocity.x = -3 + randi() % 7;
		_part.linear_velocity.z = -3 + randi() % 7;
