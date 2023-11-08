class_name HotKeyRebindButton
extends Control

@onready var label = $HBoxContainer/Label
@onready var button = $HBoxContainer/Button

@export var action_name:String=""

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_keys()
	
func set_action_name() ->void:
	label.text="Unassigned"
	
	match action_name:
		"Left":
			label.text="Move left"
		"Right":
			label.text="Move right"
		"Forward":
			label.text="Move forward"
		"Backward":
			label.text="Move backward"
		"Jump":
			label.text="Jump"
		"Crouch":
			label.text="Crouch"
		"Sprint":
			label.text="Sprint"
		"Dance":
			label.text="Taunt Dance"
		"Die":
			label.text="_DEBUG_ Die"
		"ToggleMouseCaptured":
			label.text="Pause menu"

func set_text_for_keys()->void:
	var action_events= InputMap.action_get_events(action_name)
	var action_event=action_events[0]
	var action_keycode=OS.get_keycode_string(action_event.physical_keycode)
	button.text="%s" %action_keycode

func _on_button_toggled(button_pressed):
	if button_pressed:
		button.text="Press a key..."
		set_process_unhandled_key_input(button_pressed)
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name!=self.action_name:
				i.button.toggle_mode=false
				i.set_process_unhandled_key_input(false)
	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name!=self.action_name:
				i.button.toggle_mode=true
				i.set_process_unhandled_key_input(false)
		set_text_for_keys()

func _unhandled_key_input(event):
	rebind_action_key(event)
	button.button_pressed=false


func rebind_action_key(event)->void:
	var is_duplicate=false
	var action_event=event
	var action_keycode=OS.get_keycode_string(action_event.physical_keycode)
	for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name!=self.action_name:
				if i.button.text=="%s" %action_keycode:
					is_duplicate=true
					break
	if not is_duplicate:
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name,event)
		set_process_unhandled_key_input(false)
		set_text_for_keys()
		set_action_name()
	
