extends RigidBody3D


@export var arrow_speed:float
var hit_something:bool=false

#var gravity:float =ProjectSettings.get_setting("physics/3d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_parent().ready_to_shoot
	top_level=true
	apply_impulse(get_transform().basis.y.normalized()*arrow_speed)

func _on_body_entered(body):
	hit_something=true
	if(body!=get_parent()):
		print_debug("it hit ",body)
		top_level=false
		call_deferred("reparent",body)
		freeze=true
		if body.is_in_group("Players"):
			body.is_dead=true
			

func _on_timer_timeout():
	if(freeze==false):
		queue_free()
