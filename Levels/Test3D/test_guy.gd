extends CharacterBody3D

@export var cam_sensitivity: float = 0.02
@export var accel: float = 0.8
@export var friction: float = 0.5
@export var max_speed: float = 8.0
@export var curMaxSpeed = 0.0

@onready var playerArt = $Boxboi
@onready var wireManager = $WireManager
var playerState: Enums.PlayerState

var wireForce : Vector3

var is_dragging: bool = false

var desiredVelocity = Vector3.ZERO

var deathTimer = 0.0

func _ready():
	set_state(Enums.PlayerState.DEFAULT)
	curMaxSpeed = max_speed

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
		Disconnect()
	
	var wireTension = clampf(inverse_lerp(0.6, 1.05, wireManager.wireForce), 0.0, 1.0)
	wireForce = wireManager.vectorToLast * (wireTension * max_speed)
	
	if wireManager.currentlyConnected:
		curMaxSpeed = max_speed
	else:
		var speedMult = inverse_lerp(0.0, 0.2, clamp(wireManager.curBattery, 0.0, 1.0))
		
		curMaxSpeed = max_speed * 1.2 * clamp(speedMult, 0.0, 1.0)
	
	desiredVelocity = desiredVelocity.move_toward(movement_dir * curMaxSpeed, cur_accel)
	velocity = desiredVelocity + wireForce
	
	# Camera stuff
	var camDelta: float = Input.get_axis("cam_left", "cam_right")
	if camDelta != 0.0:
		rotate_y(camDelta * cam_sensitivity * -1.0)
		playerArt.rotate_y(camDelta * cam_sensitivity)
	
	playerArt.DoLocomotionAnimation(desiredVelocity / max_speed, movement_dir)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_dragging = true
		else:
			is_dragging = false

# Rotate camera around y axis by mouse click + drag
#func _unhandled_input(event):
#	if event is InputEventMouseMotion && is_dragging:
#		rotate_y(-event.relative.x * cam_sensitivity)
#		playerArt.rotate_y(event.relative.x * cam_sensitivity)

func _physics_process(delta):
	if wireManager.curBattery <= 0.0:
		set_state(Enums.PlayerState.DYING)
	if playerState == Enums.PlayerState.DEFAULT:
		get_input()
		move_and_slide()
		if deathTimer != 0.0:
			deathTimer = 0.0
	elif playerState == Enums.PlayerState.DYING:
		DeathState(delta)
	
func DeathState(delta):
	deathTimer += delta
	if deathTimer > 2.5:
		Respawn()

func Respawn():
	position = wireManager.lastConnected.global_position + (wireManager.lastConnected.global_transform.basis.z * 2.0) + Vector3.UP
	wireManager.Disconnect()
	wireManager.SwapCurrentlyConnected(wireManager.lastConnected)
	set_state(Enums.PlayerState.DEFAULT)

func _process(delta):
	if $Music.playing == false:
		$Music.play()
		$ShipAmbience.play()

func _on_tilt_timer_timeout():
	Disconnect()
	
	
func Disconnect():
	wireManager.Disconnect()
	$CableSnap.play()
	
func set_state(newState: Enums.PlayerState):
	playerState = newState
	match playerState:
		Enums.PlayerState.DEFAULT:
			playerArt.Reset()
		Enums.PlayerState.TALKING:
			playerArt.DoLocomotionAnimation(Vector3.ZERO, Vector3.ZERO)
		Enums.PlayerState.DYING:
			playerArt.CallPowerDownAnim()	
			

	
#func _Footsteps():
#	if velocity.length() > 0:
#		pass
#	else:
#		if $Timer.time_left <= 0:
#			$Footsteps.pitch_scale = randf_range(0.8, 1.2)
#			$Footsteps.play()
#			$Timer.start(0.2)
