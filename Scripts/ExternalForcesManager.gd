extends CharacterBody3D

@export var tiltForce : Vector3
var targetTiltForce : Vector3
@export var acceleration = 1.0

func _physics_process(delta):
	velocity = tiltForce
	move_and_slide()
	pass

func _process(delta):
	if(targetTiltForce.length() > 0 && tiltForce.length() >= targetTiltForce.length()):
		targetTiltForce = Vector3.ZERO
	tiltForce = tiltForce.move_toward(targetTiltForce, acceleration * delta)


func _on_tilt_timer_timeout():
	pass # Replace with function body.
