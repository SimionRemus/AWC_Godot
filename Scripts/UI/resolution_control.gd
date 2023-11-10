extends Control

@onready var option_button = $HBoxContainer/OptionButton

const RESOLUTION_DICTIONARY: Dictionary={
	"1366 x 768"  : Vector2i(1366,768), #3.24%
	"1920 x 1080" : Vector2i(1920,1080),
	"2560 x 1440" : Vector2i(2560,1440),
	"2560 x 1600" : Vector2i(2560,1600),
	"3840 x 2160" : Vector2i(3840,2160)
}
func _ready():
	option_button.item_selected.connect(on_resolution_changed)
	add_resolution_items()
#	
func add_resolution_items()->void:
	for resolution_size_text in RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size_text)
	
func on_resolution_changed(index:int)->void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
