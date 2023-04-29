extends CharacterBody3D

@export var mouse_sensitivity: float = 0.002
@export var accel: float = 0.8
@export var friction: float = 0.5
@export var max_speed: float = 8.0

@onready var little_guy: Node3D = $Boxboi

var is_dragging: bool = false

func get_input():
	var cur_accel = 0.0
	
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)

	# if we are pressing input accelerate, if not, decelerate
	if abs(input.x) > 0.0 || abs(input.y) > 0.0:
		cur_accel = accel
		little_guy.rotation.y = atan2(-input.x, -input.y)
		
	else:
		cur_accel = friction
	
	velocity = velocity.move_toward(movement_dir * max_speed, cur_accel)

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
		little_guy.rotate_y(event.relative.x * mouse_sensitivity)

func _physics_process(delta):
	get_input()
	move_and_slide()
