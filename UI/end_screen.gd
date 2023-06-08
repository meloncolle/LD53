extends Control

func _ready():
	# DO NOT make paths like this in the final please
	$ColorRect/BackButton.pressed.connect(get_tree().get_root().get_child(2)._on_press_quit)


func _input (event: InputEvent):
	# dont allow pausing if we're on this menu
	if visible && event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
