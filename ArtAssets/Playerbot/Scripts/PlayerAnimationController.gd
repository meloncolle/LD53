extends Node3D

@onready var animationTree = $AnimationTree
@onready var animationMode = animationTree.get("parameters/playback")

@export var boxModel : Node3D
@export var faceModel : Node3D
	
func CallInteractAnim():
	animationMode.travel("Interact")
	
func CallPowerDownAnim():
	animationMode.travel("PowerDown")
	
func Reset():
	animationMode.travel("Locomotion")
	
func Stop():
	animationMode.travel("Stopping")
	$Skid.play()
	
func DoLocomotionAnimation(mvmtVec, inputVec): #make sure movement vec is devided by maxspeed BEFORE its used as an argument
	animationTree.set("parameters/Locomotion/mvmtBlend/blend_position", mvmtVec.length()) 
	#print_debug(inputVec)
	if inputVec.length() < 0.01  && mvmtVec.length() > 0.0 or inputVec.dot(mvmtVec) < 0.01 && mvmtVec.length() > 0.0:
		Stop()
	else:
		animationMode.travel("Locomotion")
	
