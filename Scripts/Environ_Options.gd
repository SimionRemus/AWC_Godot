extends GridContainer

@onready var world_environment = %WorldEnvironment as WorldEnvironment
@onready var directional_light_3d = %DirectionalLight3D as DirectionalLight3D
@onready var shadow_qual_btn = $Shadow_Qual_BTN


# Called when the node enters the scene tree for the first time.
func _ready():
	shadow_qual_btn.add_item("Fast",0)
	shadow_qual_btn.add_item("Good",1)
	shadow_qual_btn.add_item("Best",2)
	shadow_qual_btn.selected=2



func _on_sdfgi_btn_toggled(button_pressed):
	world_environment.environment.sdfgi_enabled=button_pressed

func _on_ssao_btn_toggled(button_pressed):
	world_environment.environment.ssao_enabled=button_pressed

func _on_glow_btn_toggled(button_pressed):
	world_environment.environment.glow_enabled=button_pressed

func _on_shadows_btn_toggled(button_pressed):
	directional_light_3d.shadow_enabled=button_pressed

func _on_shadow_qual_btn_item_selected(index):
	directional_light_3d.directional_shadow_mode=index
