extends Control

@export var main_menu:Control
@onready var ip_to_join = $MarginContainer/VBoxContainer/Join/IP_to_join

@onready var external_ip = $MarginContainer/VBoxContainer/HBoxContainer/External_IP

func _ready():
#	external_ip.text=NetworkManager.external_IP
	pass

func _on_host_game_pressed():
	NetworkManager._on_host_game_pressed()


func _on_join_game_pressed():
	NetworkManager._on_join_game_pressed(ip_to_join.text)
	#to do: handle invalid IPs

func _on_return_pressed():
	hide()
	main_menu.show()
	
