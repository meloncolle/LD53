extends CharacterBody2D

@export var move_speed: float = 300

@onready var body_size: Vector2 = $CollisionShape2D.shape.size

var move_direction: Vector2 = Vector2.ZERO

func _ready():
		move_direction = Vector2(
		randf_range(-1,1),
		randf_range(-1,1)
	)
	
func _physics_process(_delta):
	if ((position.y - body_size.y * 0.5) <= 0 ||
		(position.y + body_size.y * 0.5) >= get_viewport().size.y):
		move_direction.y *= -1
		
	if ((position.x - body_size.x * 0.5) <= 0 ||
		(position.x + body_size.x * 0.5) >= get_viewport().size.x):
		move_direction.x *= -1
	
	velocity = move_direction * move_speed
	move_and_slide()
