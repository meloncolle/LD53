extends Node3D

var currentlyConnected
var currentlyTouching

var vectorToLast : Vector3
var wireForce = 0.0

var curBattery = 1.0
@export var batteryDrainTime = 5.0
var unpluggedTimer = 0.0

func _process(delta):
	if currentlyConnected:
		var lastPoint = currentlyConnected.wire.points[-1] if currentlyConnected.wire.points.size() > 0 else currentlyConnected.wire.startPoint
		vectorToLast = (lastPoint - self.global_position)
		vectorToLast.y = 0.0
		vectorToLast = vectorToLast.normalized()
		wireForce = currentlyConnected.wire.totalLength / currentlyConnected.wire.maxWireLength
	else:
		wireForce = 0.0
		unpluggedTimer += delta
		
	curBattery = 1.0 - (unpluggedTimer / batteryDrainTime)

func Disconnect():
	if currentlyConnected:
		currentlyConnected.wire.target = null
		currentlyConnected.wire.ResetPoints()
		#currentlyConnected.wire.UpdatePoints()
		currentlyConnected = null
		unpluggedTimer = 0.0

func SwapCurrentlyConnected(newConnected):
	if newConnected != currentlyConnected:
		if currentlyConnected:
			currentlyConnected.wire.target = null
			currentlyConnected.wire.points.push_back(newConnected.plugPoint.global_position)
			currentlyConnected.wire.UpdatePoints()
		
		currentlyConnected = newConnected
		currentlyConnected.wire.ResetPoints()
		currentlyConnected.wire.target = self
		currentlyConnected.wire.UpdatePoints()

func _on_interactor_area_body_entered(_body):
	#if body.tag == npc
	#do smt
	pass # Replace with function body.

func StartedTouchingArea(body):
	if body.is_in_group("interactable"):
		currentlyTouching = body
		SwapCurrentlyConnected(body)#make this based on buttonpress while currently touching isnt null

func StoppedTouchingArea(body):
	if body.is_in_group("interactable") and body == currentlyTouching:
		currentlyTouching = null
