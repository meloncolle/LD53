extends Control

@export var player: CharacterBody3D

@export var wire_remaining: float = 1.0

var cord_color: Color = Color8(90, 88, 147)
var outline_color: Color = Color8(67, 66, 110)

var radius: float = 50
var max_angle: float = PI * 2
var min_angle: float = PI * 0.5
var thickness: float = 24.0

@onready var cord_head: Sprite2D = $Control/CordHead

func _ready() -> void:
	#player.wireManager.connection_set.connect(self._on_connection_set.bind("currentlyConnected"))
	player.wireManager.changed_length.connect(self._on_changed_length)
	

func _on_changed_length():
	update_display(1 - player.wireManager.wireForce)
	queue_redraw()

func _on_connection_set(currentlyConnected):
	if currentlyConnected != null:
		print("Connected to new guy")
	else:
		print("disconnected")
	

func _draw():
	_on_changed_length()
	
func update_display(remaining: float) -> void:
	var lerpval = lerp(min_angle, max_angle, remaining)
	# why these numbers i hate math!!!!!!!!!!!
	cord_head.position = Vector2(0, 25) + Vector2(cos(lerpval), sin(lerpval)) * 170
	cord_head.rotation = lerpval
	draw_arc(Vector2.ZERO, radius, min_angle, lerpval, 32, outline_color, thickness, true)
	draw_arc(Vector2.ZERO, radius, min_angle, lerpval, 32, cord_color, thickness - 8, true)
