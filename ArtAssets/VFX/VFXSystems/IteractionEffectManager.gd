extends Node3D

@export var crossModel : Node3D
@export var tubeModel : Node3D

@export var onColor : Color
@export var offColor : Color

var interactable = false

func _ready():
	ToggleInteractable(true)

func ToggleInteractable(_interactable : bool):
	if _interactable:
		interactable = true
		crossModel.visible = false;
		crossModel.get_child(0).get_surface_override_material(0).set_shader_parameter("Color", onColor)
		tubeModel.get_child(0).get_surface_override_material(0).set_shader_parameter("Color", onColor)
	else:
		interactable = false
		crossModel.visible = true
		crossModel.get_child(0).get_surface_override_material(0).set_shader_parameter("Color", offColor)
		tubeModel.get_child(0).get_surface_override_material(0).set_shader_parameter("Color", offColor)
