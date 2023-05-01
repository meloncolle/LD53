extends Node3D

@export var botRef : Node3D
var parented = false

@export var hotDogCurve : Curve
# Called when the node enters the scene tree for the first time.
func _ready():
	
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parented:
		position = botRef.handTransform.origin + (botRef.handTransform.basis.x * 0.3) + (botRef.handTransform.basis.y * .4)
		basis = botRef.handTransform.basis
	pass
	
func Toss():
	var startPos = global_position
	parented = false
	var dir = botRef.basis.z
	
	var timer = 0.0
	
	while timer < 1.2:
		await(get_tree().create_timer(0.014).timeout)
		var desiredPos = startPos.lerp(botRef.global_position - (dir * 4.0) + (Vector3.UP * 0.0), timer / 2.0)
		
		desiredPos.y += hotDogCurve.sample(timer / 1.2)
		
		global_position = desiredPos
		timer += 0.014
	
	#global_position = botRef.global_position - (dir * 2.0)
