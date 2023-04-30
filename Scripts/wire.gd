extends Node3D

@onready var lineRenderer = $LineRenderer

@export var startPoint : Vector3
@export var startTransform : Node3D
@export var target : Node3D

@export var maxWireLength = 5.0

@export var distanceThreshhold = 0.25
@export var minPointDistance = 0.1
@export var unwindStartDotProduct = 0.8

@export var normalPush = 0.1

var points : Array
var rayCastHits : Array

var totalLength = 0.0

var lastPos = Vector3.ZERO

func _ready():
	if(startTransform):
		startPoint = startTransform.global_position
	pass

func _process(_delta):

	var dist = (target.global_position - lastPos).length() if target else 0.0
	if dist > distanceThreshhold:
		UpdatePoints()
		
func UpdatePoints():
	#raycast from target to last entry, if hit register new entry and repeat
		if target : 
			CheckTargetToLast()
		#if the dot product of last to target and the hit normal is greater than 0, dereigster last
			if points.size() > 0:
				CheckTargetToSecondLast()
		#update line renderer
		var rendererPoints = points.duplicate(false)
		for n in rayCastHits.size():
			rendererPoints[n] = points[n] + (rayCastHits[n].normal * normalPush)
			
		rendererPoints.push_front(startPoint)
		if target: 
			rendererPoints.push_back(target.global_position)
	
		lineRenderer.points = rendererPoints.duplicate(false)
		
		totalLength = 0.0
		for n in rendererPoints.size() - 1:
			var p1 = rendererPoints[n]
			var p2 = rendererPoints[n + 1]
			p1.y = 0.0
			p2.y = 0.0
			totalLength += (p2 - p1).length()
		
		if target:
			lastPos = target.global_position
			

func ResetPoints():
	points.clear()
	rayCastHits.clear()
	lineRenderer.points.clear()

func CheckTargetToLast() -> bool:
	
	var rayDestination = points[points.size() - 1] if points.size() > 0 else startPoint
	
	var hitInfo = CheckRay(target.global_position, rayDestination)
	if hitInfo and (hitInfo.position - rayDestination).length() > 0.15:
		rayCastHits.push_back(hitInfo)
		points.push_back(hitInfo.position)
		return true
	else:
		return false
		
func CheckTargetToSecondLast():
	var lastSeg = target.global_position - points[points.size() - 1]
	lastSeg.y = 0.0
	var secondLastPoint = points[points.size() - 2] if points.size() > 1 else startPoint
	var secondLastSeg = points[points.size() - 1] - secondLastPoint
	secondLastSeg.y = 0.0
	
	#var dot = lastSeg.normalized().dot(secondLastSeg.normalized())
	
	#testing shit
	var cross = lastSeg.cross(secondLastSeg)
	var cross2 = secondLastSeg.cross(rayCastHits[-1].normal)
#	print_debug(cross)
#	print_debug(cross2)
	
	#print_debug(dot)
	if sign(cross.y) != sign(cross2.y):
		var result = CheckRay(target.global_position, secondLastPoint)
		if(result.is_empty()):
			points.pop_back()
			rayCastHits.pop_back()
		else :
			var rayVec = target.global_position - result.position
			if  rayVec.length() > lastSeg.length() + minPointDistance:
				points.pop_back()
				rayCastHits.pop_back()
			
#		if result and (target.global_position - result.position).length() > lastSeg.length() + 0.1 or result == null:
			
		
func CheckRay(origin, destination) -> Dictionary:
	var space_state = get_world_3d().direct_space_state
	
	var _newDestination = destination + ((origin - destination).normalized() * 0.1)
	
	var query = PhysicsRayQueryParameters3D.create(origin, destination)		
	var result = space_state.intersect_ray(query)
	
	return result
