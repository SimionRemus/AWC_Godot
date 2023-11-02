extends Marker3D

@onready var camera_3d = $"../../Head/Camera3D"
@onready var head = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _physics_process(delta):
	rotation.x=0
	rotation.y=0
	rotation.z=head.rotation.x
