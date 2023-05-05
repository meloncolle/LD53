extends Node3D

@export var target: Node3D
@export var deadzone := 1.0
@export var followSpeed = 10.0

@onready var cam = $Camera3D

var initialOffset : Vector3
var currentyYRot = 0.0

var focusPoint : Vector3

var targetDist
var currentDist

func _ready():
	initialOffset = cam.global_position - target.global_position
	targetDist = initialOffset.length()
	focusPoint = target.global_position
	
func _process(delta):
	followCam(delta)
	pass
	
func talkCam():
	pass

func followCam(delta):
	var targetScreenPos = cam.unproject_position(target.global_position)
	var viewportSize = cam.get_viewport().get_visible_rect().size
	targetScreenPos.x /=  viewportSize.x
	targetScreenPos.y /=  viewportSize.y
	
	targetScreenPos = targetScreenPos * 2.0 - Vector2.ONE
	var screenDist = inverse_lerp(deadzone, 1.0, targetScreenPos.length())
	var curFollowSpeed = followSpeed * clamp(screenDist, 0.0, 1.0)
	
	focusPoint = focusPoint.lerp(target.global_position, curFollowSpeed * delta)
	
	currentDist = CheckRay(focusPoint + (initialOffset.rotated(Vector3.UP, currentyYRot)), focusPoint)
	
	var offset = initialOffset.normalized() * currentDist
	var currentPosition = focusPoint + (offset.rotated(Vector3.UP, currentyYRot))
	
	cam.global_position = currentPosition
	cam.look_at(focusPoint)

func CheckRay(origin, destination) -> float :
	
	var space_state = get_world_3d().direct_space_state

	#needs lots of filtering
	
	var query = PhysicsRayQueryParameters3D.create(origin, destination)		
	var result = space_state.intersect_ray(query)
	
	if result:
		return (result.position - origin).length()
	
	return targetDist
