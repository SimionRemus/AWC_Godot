extends Control

@onready var option_button = $HBoxContainer/OptionButton as OptionButton

const WINDOW_MODE_ARRAY: Array[String]=[
	"Fullscreen Bordered",
	"Fullscreen Borderless",
	"Window Bordered",
	"Window Borderless"
]

func _ready():
	option_button.item_selected.connect(on_window_mode_changed)
	for i in WINDOW_MODE_ARRAY:
		option_button.add_item(i)
	option_button.selected=2


func on_window_mode_changed(index:int)->void:
	match index:
		0: # Fullscreen Bordered
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		1: # Fullscreen Borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
		2: # Window Bordered
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		3: # Window Borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
