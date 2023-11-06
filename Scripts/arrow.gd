extends RigidBody3D


@export var arrow_speed:float
var hit_something:bool=false
var player:Node3D
#var gravity:float =ProjectSettings.get_setting("physics/3d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	player=get_parent()
	await get_parent().ready_to_shoot
	top_level=true
	apply_impulse(get_transform().basis.y.normalized()*arrow_speed)

func _on_body_entered(body):
	hit_something=true
	if(body!=get_parent()):
#		print_debug("it hit ",body,get_multiplayer_authority())
		top_level=false
		if !body.is_in_group("Players"):
			freeze=true
		if body.is_in_group("Players"):
			body.is_dead=true
			player.score+=1
			call_deferred("reparent",body.get_node("ArrowsHit"))
		else:
			call_deferred("reparent",body)
			

func _on_timer_timeout():
	if(hit_something==false):
		queue_free()
