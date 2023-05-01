extends Node3D

@onready var animationTree = $AnimationTree
@onready var animationMode = animationTree.get("parameters/playback")

func CallOpen():
	animationMode.travel("open")
