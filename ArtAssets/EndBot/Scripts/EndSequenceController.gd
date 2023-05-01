extends Node

@export var botArt : Node3D
@export var boxArt : Node3D

@export var boxHeightCurve : Curve
@export var boxLerpTime = 1.0

var boxTargetPos : Vector3
var boxTargetRot : Vector3

var player

var activated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	boxTargetPos = boxArt.global_position
	boxTargetRot = boxArt.global_rotation
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if(activated):
		return
	activated = true
	player = body
	$Area3D.visible = false
	
	#startSequence
	botArt.CallGrab()
	boxArt.CallOpen()
	
