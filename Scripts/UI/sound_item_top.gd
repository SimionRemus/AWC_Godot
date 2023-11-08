extends Control

@export var bus_name:String
@onready var h_slider = $HBoxContainer/HSlider
@onready var label = $HBoxContainer/Label


func _ready():
	label.text=bus_name
