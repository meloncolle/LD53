extends Node3D

@onready var animationTree = $AnimationTree
@onready var animationMode = animationTree.get("parameters/playback")

@export var skel : Skeleton3D

var handId
var handTransform

func _ready():
	handId = skel.find_bone("hand.l")
	print_debug(handId)
	handTransform = skel.get_bone_global_pose(handId) # maybe needs to move to process idk
	print_debug(handTransform)

func _process(delta):
	handTransform = skel.get_bone_global_pose(handId) # maybe needs to move to process idk

func CallGrab():
	animationMode.travel("grab")
	
func CallToss():
	animationMode.travel("toss")
	
