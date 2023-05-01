extends Node3D

var lastConnected
var currentlyConnected
var currentlyTouching

var vectorToLast : Vector3
var wireForce = 0.0

var curBattery = 1.0
@export var batteryDrainTime = 5.0
var unpluggedTimer = 0.0

signal connection_set(currentlyConnected)
signal changed_length(newLength: float)
signal changed_charge(newCharge: float)

func _process(delta):
	if currentlyConnected:
		var lastPoint = currentlyConnected.wire.points[-1] if currentlyConnected.wire.points.size() > 0 else currentlyConnected.wire.startPoint
		vectorToLast = (lastPoint - self.global_position)
		vectorToLast.y = 0.0
		vectorToLast = vectorToLast.normalized()
		wireForce = currentlyConnected.wire.totalLength / currentlyConnected.wire.maxWireLength
		emit_signal("changed_length", 1.0 - wireForce)
	else:
		wireForce = 0.0
		emit_signal("changed_length", 1.0 - wireForce)
		unpluggedTimer += delta
		
	curBattery = 1.0 - (unpluggedTimer / batteryDrainTime)
	emit_signal("changed_charge", curBattery)

func Disconnect():
	if currentlyConnected:
		currentlyConnected.wire.target = null
		currentlyConnected.wire.ResetPoints()
		#currentlyConnected.wire.UpdatePoints()
		currentlyConnected = null
		unpluggedTimer = 0.0
		emit_signal("connection_set", currentlyConnected)
		

func SwapCurrentlyConnected(newConnected):
	
	if newConnected != currentlyConnected:
		if currentlyConnected:
			currentlyConnected.wire.target = null
			currentlyConnected.wire.points.push_back(newConnected.plugPoint.global_position)
			currentlyConnected.wire.UpdatePoints()
		
		currentlyConnected = newConnected
		lastConnected = currentlyConnected
		currentlyConnected.wire.ResetPoints()
		currentlyConnected.wire.target = self
		currentlyConnected.wire.UpdatePoints()
		emit_signal("connection_set", currentlyConnected)

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
