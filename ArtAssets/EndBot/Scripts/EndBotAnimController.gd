extends Node

@onready var animationTree = $AnimationTree
@onready var animationMode = animationTree.get("parameters/playback")

func CallGrab():
	animationMode.travel("grab")
	
func CallIdle():
	animationMode.travel("idle")
