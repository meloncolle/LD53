extends Node3D

@export var botRef : Node3D
var parented = false
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
	var dir = botRef.basis.z - botRef.basis.x
	
	var timer = 0.0
	
	while timer < 2.0:
		await(get_tree().create_timer(0.014).timeout)
		var desiredPos = startPos.lerp(dir + (Vector3.UP * 0.15), timer / 2.0)
		
		
		global_position = desiredPos
		timer += 0.014
	
	global_position = botRef.global_position - (dir * 3.0)
