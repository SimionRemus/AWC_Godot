extends CharacterBody3D

##| DEBUG and scoring|##
@onready var name_label = $Name
@onready var score_label = $Score
var score:int=0
@onready var skill_tree = $Skill_tree
var pause_mouse_movement:bool = false

##| Sound |##
@onready var ap_nock = $AP_container/AP_nock
@onready var ap_release = $AP_container/AP_release

##| Game Vars |##

@onready var head=$Head
@onready var collShape=$CollisionShape3D
@onready var collShapeCrouch=$CollisionShape3D_crouch
@onready var ray_cast_3d = $RayCast3D
@onready var cam=$Head/Camera3D
@onready var animation_tree = $AnimationTree
@onready var animation_player = $Archer_packed/AnimationPlayer
@onready var general_skeleton = %GeneralSkeleton
@onready var aim_ik = $Archer_packed/Armature/GeneralSkeleton/Aim_IK
@onready var reload_timer = $Reload_Timer

var paused:bool=false
signal pause
signal unpause
@onready var signalRouter=get_node("/root/SignalRouter")
@onready var spawn_points=get_node("/root/World/SpawnPoints")


@onready var ik_target_slot = $IK_Target_Slot
@onready var nocked_arrow = $Archer_packed/Armature/GeneralSkeleton/BA3D_ArrowHand/ArrowSlot

const walkSpeed:float= 5.0
const runSpeed:float=10.0
const crouchSpeed:float=2.5
const crouchDepth:float=0.5
var crouch_raycast:bool=false
const jumpVelocity:float = 6
var was_on_floor:bool=true
var was_respawned:bool=false
var disable_movement:bool=false
const mouse_sens:float=0.2
var lerp_speed:float=10.0
var direction:Vector3=Vector3.ZERO
var currentSpeed:float=walkSpeed
var mouse_mode_captured:bool=true

var arrow_scene=preload("res://Scenes/arrow.tscn")
@export var arrow_speed:float
signal ready_to_shoot
var reloading=false
var shooting:bool=false
var shooting_sound_started:bool=false
@export var is_dead:bool
@onready var arrows_hit = $ArrowsHit


@export var aiming:bool=false
var aiming_sound_started:bool=false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
func _ready():
	if not is_multiplayer_authority():
		return
	cam.current = is_multiplayer_authority()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_mode_captured=true
	is_dead=false
	name_label.text="Player "+name
	score_label.text=str(score)

func _process(delta):
	score_label.text=str(score)
	if Input.is_action_just_pressed("Skills"):
		skill_tree.visible= not skill_tree.visible
		if skill_tree.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pause_mouse_movement=true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			pause_mouse_movement=false

func _input(event):
	if not is_multiplayer_authority():
		return
	if event is InputEventMouseMotion and !pause_mouse_movement:
		if(!paused and (!disable_movement or aiming)):
			rotate_y(deg_to_rad(-event.relative.x*mouse_sens))
			head.rotate_x(deg_to_rad(-event.relative.y*mouse_sens))
			head.rotation.x=clamp(head.rotation.x,deg_to_rad(-85),deg_to_rad(90))
			head.rotation.y=0
			head.rotation.z=0
	if Input.is_action_just_pressed("ToggleMouseCaptured"):
		if mouse_mode_captured:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_mode_captured=false
			pause.connect(signalRouter._on_pause)
			pause.emit()
			paused=true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_mode_captured=true
			unpause.connect(signalRouter._on_unpause)
			unpause.emit()
			paused=false

func _physics_process(delta):
	if not is_multiplayer_authority():
		return
#	if is_dead:
#		print_debug(name," died")
#		return
	crouch_raycast=ray_cast_3d.is_colliding()
	if Input.is_action_pressed("Crouch"):
		currentSpeed=crouchSpeed
		head.position.y=lerp(head.position.y,1.8-crouchDepth,delta*lerp_speed)
		head.position.z=lerp(head.position.z,-0.35,delta*lerp_speed)
		collShape.disabled=true
		collShapeCrouch.disabled=false
	elif !crouch_raycast:
		collShape.disabled=false
		collShapeCrouch.disabled=true
		head.position.y=lerp(head.position.y,1.8,delta*lerp_speed)
		head.position.z=lerp(head.position.z,0.0,delta*lerp_speed)
		if Input.is_action_pressed("Sprint"):
			currentSpeed=runSpeed
		else:
			currentSpeed=walkSpeed
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jumpVelocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)
	if direction:
		velocity.x = direction.x * currentSpeed
		velocity.z = direction.z * currentSpeed
	else:
		if(is_on_floor()):
			velocity.x = move_toward(velocity.x, 0, 0.00001)
			velocity.z = move_toward(velocity.z, 0, 0.00001)

	#Animation stuff
	animation_tree.set("parameters/Onground/Crouch_walk/blend_position",input_dir)
	animation_tree.set("parameters/Onground/Stand_walk/blend_position",input_dir)
	animation_tree.set("parameters/Onground/Run/blend_position",input_dir)
	
	animation_tree.set("parameters/Onground/conditions/idle",input_dir==Vector2.ZERO and is_on_floor())
	animation_tree.set("parameters/Onground/conditions/walk",!Input.is_action_pressed("Sprint") and input_dir!=Vector2.ZERO and is_on_floor())
	animation_tree.set("parameters/Onground/conditions/crouch",Input.is_action_pressed("Crouch") and  is_on_floor())
	animation_tree.set("parameters/Onground/conditions/run",!Input.is_action_pressed("Crouch") and Input.is_action_pressed("Sprint") and is_on_floor() and input_dir!=Vector2.ZERO)
	animation_tree.set("parameters/Onground/conditions/standing",!Input.is_action_pressed("Crouch") and !Input.is_action_pressed("Sprint") and is_on_floor() and !crouch_raycast)
	animation_tree.set("parameters/conditions/jump",!is_on_floor())
	animation_tree.set("parameters/conditions/landed",!was_on_floor and is_on_floor())
	animation_tree.set("parameters/Onground/conditions/outside",!is_on_floor() or !was_on_floor and is_on_floor() or Input.is_action_just_pressed("Dance") or Input.is_action_just_pressed("Aim"))
	animation_tree.set("parameters/conditions/dance", Input.is_action_just_pressed("Dance"))
	animation_tree.set("parameters/conditions/death", Input.is_action_just_pressed("Die") or is_dead)
	
	if(was_respawned):
		animation_tree.set("parameters/conditions/respawn",false)
	was_respawned=animation_tree.get("parameters/conditions/respawn")
	was_on_floor=is_on_floor()


	if(shooting):
		shoot_arrow()
	else:
		shooting_sound_started=false	

	#Special states (death, dance)
	if(aiming and not pause_mouse_movement):
		if (ap_nock.playing==false and aiming_sound_started==false):
			ap_nock.play()
			aiming_sound_started=true
		disable_movement=true
	else:
		aiming_sound_started=false
		disable_movement=false
	if(Input.is_action_just_pressed("Dance")):
		disable_movement=true
	if(Input.is_action_just_pressed("Die") or is_dead):
#		print_debug("DIED!")
		disable_movement=true
	if(disable_movement):
		if(!aiming):
			velocity.x=move_toward(velocity.x, 0,0.00001)
			velocity.y=move_toward(velocity.y, 0,0.00001)
			velocity.z=move_toward(velocity.z, 0,0.00001)
		else:
			if(Input.is_action_just_pressed("Jump")):
				velocity.y -=jumpVelocity
			velocity.x=move_toward(velocity.x, 0,currentSpeed)
			velocity.z=move_toward(velocity.z, 0,currentSpeed)
	
	move_and_slide()

func shoot_arrow():
	if pause_mouse_movement:
		return
	nocked_arrow.visible=false
	if (ap_release.playing==false and shooting_sound_started==false):
		ap_release.play()
		shooting_sound_started=true
	var arrow=arrow_scene.instantiate()
	arrow.set_multiplayer_authority(name.to_int())
	add_collision_exception_with(arrow)
	#get_tree().get_root().get_node("World").get_node("Arrow_Holder").
	add_child(arrow,true)
	arrow.global_position=nocked_arrow.global_position
	arrow.global_rotation=nocked_arrow.global_rotation
	arrow.global_transform=nocked_arrow.global_transform
	arrow.arrow_speed=10
	ready_to_shoot.emit()
	reload_timer.start()
	reloading=true
	_on_reload_timer()
	

func end_of_dance():
	disable_movement=false;

func spawn_rand_point():
	var sp_array=spawn_points.get_children()
	var spawnpoint=sp_array[randi() % sp_array.size()]
	position=spawnpoint.position
	rotation=spawnpoint.rotation
	
func respawn_timer():
	await get_tree().create_timer(5.0).timeout
	is_dead=false
	animation_tree.set("parameters/conditions/respawn",true)
	disable_movement=false;
	spawn_rand_point()
	for a in arrows_hit.get_children():
		a.queue_free()

func _on_reload_timer():
	await reload_timer.timeout
	reloading=false

###RPCs

@rpc("reliable","any_peer","call_local")
func updateAim(id,aim):
	if !is_multiplayer_authority():
		if name==id:
			aiming=aim
	else:
		aiming=Input.is_action_pressed("Aim")
		if pause_mouse_movement:
			return
	
	if aiming and !crouch_raycast:
		aim_ik.start()
		animation_tree.set("parameters/conditions/Aim",aiming)
		animation_tree.set("parameters/conditions/NotAim",!aiming)
		if(not reloading):
			nocked_arrow.visible=true
	else:
		aim_ik.stop()
		general_skeleton.clear_bones_global_pose_override()
		animation_tree.set("parameters/conditions/Aim",aiming)
		animation_tree.set("parameters/conditions/NotAim",!aiming)
		nocked_arrow.visible=false

@rpc("reliable","authority","call_local")
func spawnBullets(id,shoot):
	if not is_multiplayer_authority():
		if name==id:
			shooting=shoot
			if shooting:
				get_node("/root/World/"+name).shoot_arrow()
	else:
		shooting=Input.is_action_just_pressed("Shoot")&& aiming and not reloading
		if shooting:
			self.shoot_arrow()

func _on_timer_timeout():
	if is_multiplayer_authority():
		rpc("updateAim",name,Input.is_action_pressed("Aim"))
		rpc("spawnBullets",name,Input.is_action_just_pressed("Shoot")&& aiming and not reloading)
