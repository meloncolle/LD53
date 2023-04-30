extends CharacterBody3D

@export var mouse_sensitivity: float = 0.002
@export var accel: float = 0.8
@export var friction: float = 0.5
@export var max_speed: float = 8.0

@onready var playerArt = $Boxboi
@onready var wireManager = $WireManager

var wireForce : Vector3

var is_dragging: bool = false

var desiredVelocity = Vector3.ZERO

func get_input():
	var cur_accel = 0.0
	
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)

	# if we are pressing input accelerate, if not, decelerate
	if abs(input.x) > 0.0 || abs(input.y) > 0.0:
		cur_accel = accel
		playerArt.rotation.y = atan2(input.x, input.y)
		
	else:
		cur_accel = friction
	
	if wireManager.wireForce >= 1:
		wireManager.Disconnect()
	
	var wireTension = clampf(inverse_lerp(0.6, 1.05, wireManager.wireForce), 0.0, 1.0)
	wireForce = wireManager.vectorToLast * (wireTension * max_speed)
	desiredVelocity = desiredVelocity.move_toward(movement_dir * max_speed, cur_accel)
	velocity = desiredVelocity + wireForce
	
	playerArt.DoLocomotionAnimation(velocity / max_speed, movement_dir)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_dragging = true
		else:
			is_dragging = false

# Rotate camera around y axis by mouse click + drag
func _unhandled_input(event):
	if event is InputEventMouseMotion && is_dragging:
		rotate_y(-event.relative.x * mouse_sensitivity)
		playerArt.rotate_y(event.relative.x * mouse_sensitivity)

func _physics_process(_delta):
	get_input()
	move_and_slide()
	
func _process(delta):
	if $Music.playing == false:
		$Music.play()
