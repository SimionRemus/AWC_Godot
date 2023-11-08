extends Control

@export var main_menu:Control

func _on_return_pressed():
	hide()
	main_menu.show()
