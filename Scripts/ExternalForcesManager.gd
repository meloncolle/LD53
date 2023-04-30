extends CharacterBody3D

@export var tiltForce : Vector3

func _physics_process(delta):
	velocity = tiltForce
	move_and_slide()
	pass

