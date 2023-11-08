extends Node

var peer = ENetMultiplayerPeer.new()
@export var playerScene: PackedScene
signal disable_ui()
signal instance_player(player_node)
var upnp: PackedScene
var upnp_node:Node
@export var PORT:int=12121
@export var external_IP:String

func _ready():
	playerScene=preload("res://Scenes/player.tscn")
	upnp=preload("res://Scenes/upnp.tscn")
	upnp_node=upnp.instantiate()
	get_tree().root.add_child.call_deferred(upnp_node)
	await upnp_node.tree_entered
	upnp_node.PORT=PORT
	external_IP=upnp_node.external_ip
#	print_debug(upnp_node.external_ip," on port ",PORT)

func _on_host_game_pressed():
	peer.create_server(PORT)
	multiplayer.multiplayer_peer=peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
#	cam.current = false
#	ui.visible = false
	emit_signal("disable_ui")
	
	## Setting up UPNP
	

func _on_join_game_pressed(ip="localhost"):
	# print_debug(ip)
	peer.create_client(str(ip),PORT)
	multiplayer.multiplayer_peer=peer
#	cam.current = false
#	ui.visible = false
	emit_signal("disable_ui")

func add_player(id=1):
	var player=playerScene.instantiate()
	player.name=str(id)
#	call_deferred("add_child",player)
	emit_signal("instance_player",player)

func exit_game(id):
	multiplayer.peer_disconnected.connect(delete_player)
	delete_player(id)

func delete_player(id):
	rpc("_delete_player",id)
	
@rpc("any_peer","call_local") func _delete_player(id):
	get_node("player "+str(id)).queue_free()
