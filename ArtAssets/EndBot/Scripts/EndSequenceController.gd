extends Node

@onready var botArt = $endBot
@onready var boxArt = $boxAnim
@onready var hotDogArt = $hotDog

@export var boxHeightCurve : Curve
@export var boxLerpTime = 1.0
@export var bounceHeight = 1.0

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

func DoEndBotVisuals():
	var playerBoxModel = player.playerArt.boxModel
	var startPos = playerBoxModel.global_position
	var startRot = playerBoxModel.global_rotation
	
	boxArt.global_position = startPos
	boxArt.global_rotation = startRot
	
	playerBoxModel.visible = false
	player.playerArt.faceModel.visible = false
	boxArt.visible = true
	
	var timer = 0.0
	while timer < boxLerpTime:
		await(get_tree().create_timer(0.042).timeout)
		var desiredPos = startPos.lerp(boxTargetPos, timer / boxLerpTime)
		var desiredRot = startRot.lerp(boxTargetRot, timer / boxLerpTime)
		desiredPos.y += boxHeightCurve.sample(timer / boxLerpTime) * bounceHeight
		
		boxArt.global_position = desiredPos
		boxArt.global_rotation = desiredRot
		
		timer += 0.042
	
	botArt.CallGrab()
	boxArt.CallOpen()
	
	#await(botArt.animationTree.animation_finished)
	await(get_tree().create_timer(4.1666).timeout)
	
	hotDogArt.parented = true
	hotDogArt.visible = true
	#toggle hotDog
	
	await(botArt.animationTree.animation_finished)
	
	await(get_tree().create_timer(2.0).timeout)
		
	botArt.CallToss()
	
	await(get_tree().create_timer(0.33).timeout)
	hotDogArt.Toss()

func _on_area_3d_body_entered(body):
	if(activated):
		return
	activated = true
	player = body
	$Area3D.visible = false
	player.wireManager.batteryDrainTime = 100000.0
	player.wireManager.curBattery = 1.0
	
	DoEndBotVisuals()
	
