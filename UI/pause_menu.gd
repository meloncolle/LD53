extends CanvasLayer

@onready var animation: AnimationPlayer = $AnimatedSprite2D/AnimationPlayer

func open():
	animation.play("pause_menu")
	
	
func close():
	animation.play_backwards("pause_menu")
	#ok idk how to wait for this.
