extends Node3D

@onready var wire = $Wire
@onready var plugPoint = $InPlugPoint

@export var targetOverride : Node3D
@export var npc_name: String

# set flag if NPC was connected to at least once
var connected: bool = false

func _ready():
	if targetOverride:
		wire.target = targetOverride
		targetOverride.get_node("WireManager").currentlyConnected = self


func _on_area_3d_body_entered(body):
	body.get_node("WireManager").StartedTouchingArea(self)
	if !connected:
		DialogueManager.show_dialogue_balloon(npc_name)
		connected = true
	$TestSound.play()


func _on_area_3d_body_exited(body):
	body.get_node("WireManager").StoppedTouchingArea(self)
