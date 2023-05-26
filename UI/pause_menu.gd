extends CanvasLayer

@onready var animation: AnimationPlayer = $AnimationPlayer

func open():
	animation.play("pause_menu")
	
func close():
	animation.play_backwards("pause_menu")
