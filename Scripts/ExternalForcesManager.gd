extends CharacterBody3D

@export var direction : Vector3
@export var targetSpeed = 5.0

@export var tiltForce : Vector3
var targetTiltForce : Vector3
@export var acceleration = 1.0

func _physics_process(delta):
	if(targetTiltForce.length() > 0 && tiltForce.length() >= targetTiltForce.length()):
		targetTiltForce = Vector3.ZERO
	tiltForce = tiltForce.move_toward(targetTiltForce, acceleration * delta)
	
	velocity = tiltForce
	move_and_slide()

func _on_tilt_timer_timeout():
	print_debug("timed out")
	targetTiltForce = direction * targetSpeed;
	direction *= -1.0
