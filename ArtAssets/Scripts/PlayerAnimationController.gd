extends Node3D

@onready var animationTree = $AnimationTree
@onready var animationMode = animationTree.get("parameters/playback")
	
func DoLocomotionAnimation(mvmtVec, inputVec): #make sure movement vec is devided by maxspeed BEFORE its used as an argument
	animationTree.set("parameters/Locomotion/mvmtBlend/blend_position", mvmtVec.length()) 
	#print_debug(inputVec)
	if inputVec.length() < 0.01  && mvmtVec.length() > 0.0 or inputVec.dot(mvmtVec) < 0.01 && mvmtVec.length() > 0.0:
		animationMode.travel("Stopping")
	else:
		animationMode.travel("Locomotion")
	pass
