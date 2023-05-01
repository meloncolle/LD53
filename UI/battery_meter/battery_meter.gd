extends Control

var current_lvl: int = 4 # 0-4
@onready var bars: Array = [$full/bar_r, $full/bar_o, $full/bar_y, $full/bar_g]



func update_display(remaining: float) -> void:
	var new_lvl: int = clamp(int(round(remaining * 4.0)), 0, 4)
	if new_lvl != current_lvl:
		current_lvl = new_lvl
		update_bars()

func update_bars():
	for i in bars.size():
		bars[i].visible = current_lvl > i
	
	if current_lvl == 0:
		$full.visible = false
		$empty.visible = true
		
func reset():
	current_lvl = 4
	
	for i in bars.size():
		bars[i].visible = true
	
	$full.visible = true
	$empty.visible = false
