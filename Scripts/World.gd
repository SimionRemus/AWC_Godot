extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var spawn_points = $SpawnPoints

var spawn_point_array:Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	spawn_point_array=spawn_points.get_children()
	NetworkManager.instance_player.connect(instance_player)
	animation_player.play("MainScreenAnimation")


func instance_player(player_node:Node3D):
	call_deferred("add_child",player_node)
	var spawnpoint=spawn_point_array[randi() % spawn_point_array.size()]
	player_node.position=spawnpoint.position
	player_node.rotation=spawnpoint.rotation
#	print_debug(player_node.name)

