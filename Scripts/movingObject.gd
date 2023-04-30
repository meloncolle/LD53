extends CharacterBody3D

var initialOffset
@export var model : Node3D

func _ready():
	initialOffset = position
	
func _physics_process(_delta):
	move_and_slide()
	model.global_position = self.global_position - initialOffset
	model.global_rotation = self.global_rotation
