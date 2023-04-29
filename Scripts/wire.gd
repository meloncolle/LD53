extends Node3D

@onready var lineRenderer = $LineRenderer

@export var startPoint : Vector3
@export var target : Node3D

@export var distanceThreshhold = 0.25
@export var minPointDistance = 0.1

@export var normalPush = 0.1

var rayCastHits : Array
var rendererPoints : Array

var lastPos = Vector3.ZERO

func _ready():

	pass

func _process(_delta):

	var dist = (target.global_position - lastPos).length() if target else 0.0
	if dist > distanceThreshhold:
		
		var prevLastPoint = rayCastHits[-1].position if rayCastHits.size() > 0 else startPoint
		
		#raycast from target to last entry, if hit register new entry and repeat
		CheckTargetToLast()
		#if the dot product of last to target and the hit normal is greater than 0, dereigster last
		if rayCastHits.size() > 0:
			CheckTargetToSecondLast()
			
		var newLastPoint = rayCastHits[-1].position if rayCastHits.size() > 0 else startPoint
		
		if newLastPoint != prevLastPoint || rendererPoints.size() == 0:
			rendererPoints.clear()
			
			for hit in rayCastHits:
				rendererPoints.push_back(hit.position + (hit.normal * normalPush))
				
			rendererPoints.push_front(startPoint)
			rendererPoints.push_back(target.global_position)
			
		else:
			# The raycasthits array didnt change from last update, so reuse it but update last element
			rendererPoints.pop_back()
			rendererPoints.push_back(target.global_position)
			
		#update line renderer	
		lineRenderer.points = rendererPoints
		lastPos = target.global_position
		
func CheckTargetToLast() -> bool:
	var rayDestination = rayCastHits[-1].position if rayCastHits.size() > 0 else startPoint
	
	var hitInfo = CheckRay(target.global_position, rayDestination)
	if hitInfo and (hitInfo.position - rayDestination).length() > 0.15:
		rayCastHits.push_back(hitInfo)
		return true
	else:
		return false
		
func CheckTargetToSecondLast():
	var lastSeg = target.global_position - rayCastHits[-1].position
	lastSeg.y = 0.0
	var secondLastPoint = rayCastHits[-2].position if rayCastHits.size() > 1 else startPoint
	var secondLastSeg = rayCastHits[-1].position - secondLastPoint
	secondLastSeg.y = 0.0
	
	var dot = lastSeg.normalized().dot(secondLastSeg.normalized())
	if dot > 0.6:
		var result = CheckRay(target.global_position, secondLastPoint)
		if(result.is_empty()):
			rayCastHits.pop_back()
		else :
			var rayVec = target.global_position - result.position
			if  rayVec.length() > lastSeg.length() + minPointDistance:
				rayCastHits.pop_back()
			
#		if result and (target.global_position - result.position).length() > lastSeg.length() + 0.1 or result == null:
			
		
func CheckRay(origin, destination) -> Dictionary:
	var space_state = get_world_3d().direct_space_state
	
	var _newDestination = destination + ((origin - destination).normalized() * 0.1)
	
	var query = PhysicsRayQueryParameters3D.create(origin, destination)		
	var result = space_state.intersect_ray(query)
	
	return result
