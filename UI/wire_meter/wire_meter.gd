extends Control

@export var wire_remaining: float = 1.0

var cord_color: Color = Color8(90, 88, 147)
var outline_color: Color = Color8(67, 66, 110)

var radius: float = 50
var max_angle: float = PI * 2
var min_angle: float = PI * 0.5
var thickness: float = 24.0

@onready var cord_head: Sprite2D = $Control/CordHead

func _draw():
	var lerpval = lerp(min_angle, max_angle, wire_remaining)
	# why these numbers i hate math!!!!!!!!!!!
	cord_head.position = Vector2(0, 25) + Vector2(cos(lerpval), sin(lerpval)) * 170
	cord_head.rotation = lerpval
	draw_arc(Vector2.ZERO, radius, min_angle, lerpval, 32, outline_color, thickness, true)
	draw_arc(Vector2.ZERO, radius, min_angle, lerpval, 32, cord_color, thickness - 8, true)
	
func update_display(remaining: float) -> void:
	wire_remaining = remaining
	queue_redraw()
