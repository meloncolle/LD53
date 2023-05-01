extends VideoStreamPlayer

func _ready():
	self.finished.connect(_on_finished)
	self.set_process(false)
	self.set_physics_process(false)
	
func _on_finished() -> void:
	play()
