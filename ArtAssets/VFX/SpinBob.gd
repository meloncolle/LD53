extends Node3D

@export var spinSpeed = 1.0
@export var bobSpeed = 1.0
@export var bobAmt = 0.25

var startPos : Vector3

var timer = 0.0

func _ready():
	startPos = position


func _process(delta):
	position = startPos + (sin(timer * bobSpeed) * Vector3.UP * bobAmt)
	rotate(Vector3.UP, delta * spinSpeed)
	
	timer += delta
	pass
