extends Node3D

@onready var wire = $Wire
@onready var plugPoint = $InPlugPoint

@export var targetOverride : Node3D

func _ready():
	if targetOverride:
		wire.target = targetOverride
		targetOverride.get_node("WireManager").currentlyConnected = self


func _on_area_3d_body_entered(body):
	body.get_node("WireManager").StartedTouchingArea(self)
	$TestSound.play()


func _on_area_3d_body_exited(body):
	body.get_node("WireManager").StoppedTouchingArea(self)
