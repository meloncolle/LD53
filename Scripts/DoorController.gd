extends Node3D

@onready var door1 = $door
@onready var door2 = $door2

@export var openSpeed = 5.0
#3 up is out of sight
var targetHeight = 0.0

var pos1 = 0.0
var pos2 = 0.0

func _process(delta):
	pos1 = move_toward(pos1, targetHeight, openSpeed * 1.5 * delta)
	pos2 = move_toward(pos2, targetHeight, openSpeed * delta)
	
	door1.position.y = pos1
	door2.position.y = pos2
	

func _on_area_3d_body_entered(body):
	targetHeight = 3.0


func _on_area_3d_body_exited(body):
	targetHeight = 0.0
