extends Button

var showing_tutorial: bool
@onready var menu: Sprite2D = $InstructionMenu
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready():
	showing_tutorial = false
	menu.visible = false
	pressed.connect(self._on_press_instructions)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed() && showing_tutorial:
			get_viewport().set_input_as_handled()
			_on_press_instructions()
	
func _on_press_instructions():
	release_focus()
	if showing_tutorial:
		animation.play_backwards("InstructionMenu")
		while await animation.animation_finished != "InstructionMenu":
			pass
		menu.visible = false
	else:
		menu.visible = true
		animation.play("InstructionMenu")
	showing_tutorial = !showing_tutorial
