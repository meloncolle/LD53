extends Node3D

var currentlyConnected
var currentlyTouching

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func SwapCurrentlyConnected(newConnected):
	if newConnected != currentlyConnected:
		currentlyConnected.wire.target = null
		currentlyConnected.wire.points.push_back(newConnected.plugPoint.global_position)
		currentlyConnected.wire.UpdatePoints()
		
		currentlyConnected = newConnected
		currentlyConnected.wire.ResetPoints()
		currentlyConnected.wire.target = self
		currentlyConnected.wire.UpdatePoints()

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
