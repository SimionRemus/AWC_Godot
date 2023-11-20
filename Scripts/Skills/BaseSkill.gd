extends Node
class_name BaseSkill

@export var skill_name : String
@export var icon : Texture2D
@export var is_activateable_skill:bool
var action_name:String=""

func set_hotkey_to_skill()->void:
	var action_events= InputMap.action_get_events(action_name)
	var action_event=action_events[0]


func _temp_code_holder():
	match action_name:
		"Trigger_Skill_1":
			pass
		"Trigger_Skill_2":
			pass
		"Trigger_Skill_3":
			pass
		"Trigger_Skill_4":
			pass
