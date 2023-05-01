extends Node3D

@export var crossModel : Node3D
@export var tubeModel : Node3D

@export var onColor : Color
@export var offColor : Color

var interactable = false

func _ready():
	ToggleInterctable()

func ToggleInterctable():
	if interactable:
		interactable = false
		crossModel.visible = true;
		crossModel.get_child(0).get_surface_override_material(0).set_shader_parameter("Color", onColor)
		tubeModel.get_child(0).get_surface_override_material(0).set_shader_parameter("Color", onColor)
	else:
		interactable = true
		crossModel.visible = false
		MeshInstance3D
		#print_debug(tubeModel.get_child(0).mesh.override_material.)
		crossModel.get_child(0).get_surface_override_material(0).set_shader_parameter("Color", onColor)
		tubeModel.get_child(0).get_surface_override_material(0).set_shader_parameter("Color", onColor)
