extends Node3D

@onready var wire = $Wire
@onready var plugPoint = $InPlugPoint
@onready var interactionIndicator = $InteractionIndicator
@export var wireLength = 1.0

@export var targetOverride : Node3D
@export var npc_name: String

# set flag if NPC was connected to at least once
var connected: bool = false
var connectable : bool = true

var player = null

var notConnectableTimer = 0.0
@export var notConnectableTime = 5.0

func _ready():
	wire.maxWireLength = wireLength
	if targetOverride:
		wire.target = targetOverride
		targetOverride.get_node("WireManager").SwapCurrentlyConnected(self)
	#print_debug(get_tree().get_root().get_child(1).get_node("Main3D/Node3D2/TiltTimer"))
	#hmmm
	get_tree().get_root().get_child(2).get_node("Main3D/Node3D/TiltTimer/WarningTimer").timeout.connect(_on_timer_timeout)

	DialogueManager.dialogue_ended.connect(_on_dialog_ended)

func _process(delta):
	if !connectable:
		notConnectableTimer += delta
		if notConnectableTimer >= notConnectableTime:
			ToggleConnectable(true)

func _on_area_3d_body_entered(body):
	if !connectable:
		return
	body.get_node("WireManager").StartedTouchingArea(self)
	if !connected:
		if player == null:
			player = body
			#idk this sucks but we need a reference to it
			
		var dialog_balloon = showDialog()
		body.set_state(Enums.PlayerState.TALKING)
		connected = true
	$TestSound.play()
	
func _on_dialog_ended(resource):
	if player != null:
		player.set_state(Enums.PlayerState.DEFAULT)
	
func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		body.get_node("WireManager").StoppedTouchingArea(self)

func _on_timer_timeout():
	notConnectableTimer = 0.0
	ToggleConnectable(false)

func ToggleConnectable(_connectable : bool):
	connectable = _connectable
	interactionIndicator.ToggleInteractable(_connectable)
	
func showDialog():
	var balloonScene = load("res://DialogAssets/custom_balloon/balloon.tscn")
	var balloon: Node = balloonScene.instantiate()
	self.add_child(balloon)
	# I think... we should have split the dialog files up by character?
	# Array will be empty if the character is not ben. It works ok but feels wrong to do
	
	balloon.start(npc_name,
		[self.get_node("endBot-game"),
	 	get_tree().get_root().get_child(2).get_node("Main3D/Node3D/UI"),
		player])
	return balloon
