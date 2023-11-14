extends TextureButton
class_name SkillNode

@onready var line_2d : Line2D = $Line2D
@onready var panel : Panel = $Panel
@onready var label : Label = $MarginContainer/Label

@export var skill_name: String

var max_level=2
var level: int=0:
	set(value):
		level=value
		label.text=str(level)+"/"+str(max_level)

	
func _ready():
	label.text="0/"+str(max_level)
	if get_parent() is SkillNode:
		line_2d.add_point(global_position+size/2)
		line_2d.add_point(get_parent().global_position + get_parent().size/2)

func _on_gui_input(event):
	if not disabled:
		if event is InputEventMouseButton and event.pressed:
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					level=min(level+1,max_level)
					line_2d.default_color = Color(0, 0.8, 0)
				MOUSE_BUTTON_RIGHT:
					var skills=get_children(true)
					for skill in skills:
						if skill is SkillNode:
							if skill.level!=0:
								return
					level=max(level-1,0)
					if level==0:
						line_2d.default_color = Color(1, 1, 1)

func _on_toggled(button_pressed)->void:
	if not disabled:	
		panel.show_behind_parent=true
		
		var skills=get_children()
		for skill in skills:
			if skill is SkillNode and level==max_level:
				skill.disabled=false
			elif skill is SkillNode and level!=max_level and level!=0:
				skill.disabled=true
			elif skill is SkillNode and level== 0:
				skill.disabled=true
			
