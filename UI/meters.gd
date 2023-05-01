extends Control

@export var player: CharacterBody3D

@onready var battery_meter: Control = $BatteryMeter
@onready var wire_meter: Control = $WireMeter

var using_battery = false

func _ready() -> void:
	player.wireManager.connect("changed_length", self._on_changed_length)
	player.wireManager.connect("changed_charge", self._on_changed_charge)
	player.wireManager.connect("connection_set", self._on_connection_set)
	_on_connection_set(player.wireManager.currentlyConnected)


func _on_changed_length(newLength: float):
	if !using_battery:
		wire_meter.update_display(newLength)

func _on_changed_charge(newCharge: float):
	if using_battery:
		battery_meter.update_display(newCharge)

# called when player connects or disconnects wire
# if currentlyConnected is null, it was triggered by disconnect
func _on_connection_set(currentlyConnected):
	set_meter(currentlyConnected == null)


func set_meter(enable_battery: bool):
	using_battery = enable_battery
	if using_battery:
		battery_meter.reset()
		battery_meter.visible = true
		wire_meter.visible = false
	else:
		battery_meter.visible = false
		wire_meter.visible = true
	
