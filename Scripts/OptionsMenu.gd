extends Control

@export var main_menu:Control
@onready var world_environment = $"../../../Environment/WorldEnvironment"

func _on_return_pressed():
	hide()
	main_menu.show()
