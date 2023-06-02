extends CharacterBody3D

@export var direction : Vector3
@export var targetSpeed = 5.0

@export var tiltForce : Vector3
var targetTiltForce : Vector3

@export var acceleration = 1.0
# This timer starts after the main TiltTimer times out
# It will delay actual tilting to allow for warning visual/sound
@export var tiltWarningTimer: Timer
var isTilting : bool = false

signal tilt_started()
signal tilt_stopped()

func _physics_process(delta):
	if(targetTiltForce.length() > 0 && tiltForce.length() >= targetTiltForce.length()):
		targetTiltForce = Vector3.ZERO
	tiltForce = tiltForce.move_toward(targetTiltForce, acceleration * delta)
	
	velocity = tiltForce
	if isTilting && velocity == Vector3.ZERO:
		isTilting = false
		emit_signal("tilt_stopped")
	elif !isTilting && velocity != Vector3.ZERO:
		isTilting = true
		emit_signal("tilt_started")
	move_and_slide()

func _on_tilt_timer_timeout():
	# Delay actual tilting
	tiltWarningTimer.start()
	await tiltWarningTimer.timeout

	targetTiltForce = direction * targetSpeed;
	direction *= -1.0
