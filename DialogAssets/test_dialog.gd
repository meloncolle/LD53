extends Node3D

@onready var resource: DialogueResource = load("res://DialogAssets/Dialog/test.dialogue")

const Balloon = preload("res://DialogAssets/custom_balloon/balloon.tscn")
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var balloon: Node = Balloon.instantiate()
		get_tree().current_scene.add_child(balloon)
		balloon.start("outlet_1")
		return
