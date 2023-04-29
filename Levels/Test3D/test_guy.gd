extends CharacterBody3D

var is_dragging: bool = false
var speed: float = 4.0
var mouse_sensitivity: float = 0.002


func _ready():
	print(transform.basis)

func get_input():
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_dragging = true
		else:
			is_dragging = false
			print(transform.basis)

# move the camera
func _unhandled_input(event):
	if event is InputEventMouseMotion && is_dragging:
		rotate_y(-event.relative.x * mouse_sensitivity)

func _physics_process(delta):
	get_input()
	move_and_slide()
