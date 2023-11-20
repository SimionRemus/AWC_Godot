extends Control
class_name SkillTree

@onready var disguise = $Skill_container/Disguise
@onready var player = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_multiplayer_authority():
		return
	if Input.is_action_just_pressed("Trigger_Skill_1"):
		disguise.rpc("use_skill",multiplayer.get_unique_id())
		
