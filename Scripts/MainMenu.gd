extends Control

@onready var main_menu = $CanvasLayer/MainMenu
@onready var play_button = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/Play_Button

@onready var play_menu = $CanvasLayer/PlayMenu
@onready var gameplay_ui = $CanvasLayer/GameplayUI

func _ready():
	NetworkManager.disable_ui.connect(_show_game_UI)
	SignalRouter.pause.connect(_pause)
	SignalRouter.unpause.connect(_unpause)

func _on_play_button_pressed():
	main_menu.hide()
	play_menu.show()

func _on_options_button_pressed():
	pass

func _on_quit_button_pressed():
	get_tree().quit()

func _show_game_UI():
	main_menu.hide()
	play_menu.hide()
	gameplay_ui.show()

func _pause():
	gameplay_ui.hide()
	main_menu.show()
	play_button.hide()
	
func _unpause():
	gameplay_ui.show()
	play_button.show()
	main_menu.hide()
