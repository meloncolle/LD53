extends Node3D

var currentlyConnected
var currentlyTouching

var vectorToLast : Vector3
var wireForce = 0.0

func _process(_delta):
	if currentlyConnected:
		var lastPoint = currentlyConnected.wire.points[-1] if currentlyConnected.wire.points.size() > 0 else currentlyConnected.wire.startPoint
		vectorToLast = (lastPoint - self.global_position).normalized()
		wireForce = currentlyConnected.wire.totalLength / currentlyConnected.wire.maxWireLength
	else:
		wireForce = 0.0

func SwapCurrentlyConnected(newConnected):
	if newConnected != currentlyConnected:
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
	print_debug("touching a collider")
	if body.is_in_group("interactable"):
		currentlyTouching = body
		SwapCurrentlyConnected(body)#make this based on buttonpress while currently touching isnt null
	else:
		print_debug("not in the right group")


func StoppedTouchingArea(body):
	if body.is_in_group("interactable") and body == currentlyTouching:
		currentlyTouching = null
