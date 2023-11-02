extends Node3D

@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	NetworkManager.instance_player.connect(instance_player)
	animation_player.play("MainScreenAnimation")


func instance_player(player_node:Node):
	call_deferred("add_child",player_node)
#	print_debug(player_node.name)

