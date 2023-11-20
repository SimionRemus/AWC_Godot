extends BaseSkill

 
signal disguise_triggered
@export var skill_level=3 as int

@onready var player = $"../../.." as Player
@onready var skill_tree = $"../.." 

@onready var activate = $Activate
@onready var deactivate = $Deactivate


func _ready():
	SignalRouter.player_disguise_finished.connect(call_rpc_skill_ended)


func call_rpc_skill_ended():
	rpc("skill_ended",multiplayer.get_unique_id())

@rpc("any_peer","call_local")
func use_skill(id)->void:
	activate.play()
	player.walkSpeed=player.default_walkSpeed*((skill_level-1)/2.0)
	player.runSpeed=player.default_runSpeed*((skill_level-1)/2.0)
	player.crouchSpeed=player.default_crouchSpeed*((skill_level-1)/2.0)
	player.get_node("Archer_packed").visible=false
	player.get_node("Decoy").visible=true
	disguise_triggered.emit()

@rpc("any_peer","call_local")
func skill_ended(id)->void:
	deactivate.play()
	player.walkSpeed=player.default_walkSpeed
	player.runSpeed=player.default_runSpeed
	player.crouchSpeed=player.default_crouchSpeed
	player.get_node("Archer_packed").visible=true
	player.get_node("Decoy").visible=false
	
