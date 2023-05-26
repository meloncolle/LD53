extends Node
var gameState: Enums.GameState
var gameScenePath: String = "res://Levels/level.tscn"
var sceneInstance: Node = null

@onready var startMenu: Control = $CanvasLayer/StartMenu
@onready var pauseMenu: CanvasLayer = $CanvasLayer/PauseMenu

func _ready():
	set_state(Enums.GameState.ON_START)
	startMenu.get_node("Panel/StartButton").pressed.connect(self._on_press_start)
	pauseMenu.get_node("Panel/VBoxContainer/ResumeButton").pressed.connect(self._on_press_resume)
	pauseMenu.get_node("Panel/VBoxContainer/QuitButton").pressed.connect(self._on_press_quit)
	#$titleAudioLoop.play()


func _input (event: InputEvent):
	if(gameState != Enums.GameState.ON_START && event.is_action_pressed("ui_cancel")):
		get_tree().paused = !get_tree().paused
		
		match gameState:
			Enums.GameState.IN_GAME:
				set_state(Enums.GameState.PAUSED)
				
			Enums.GameState.PAUSED:
				set_state(Enums.GameState.IN_GAME)
				



func set_state(newState: Enums.GameState):
	match newState:
		Enums.GameState.ON_START:
			if gameState == Enums.GameState.PAUSED:
				pauseMenu.close()
			startMenu.visible = true
			pauseMenu.visible = false
			
		Enums.GameState.IN_GAME:
			if gameState == Enums.GameState.PAUSED:
				pauseMenu.close()
			startMenu.visible = false
			pauseMenu.visible = false
			
		Enums.GameState.PAUSED:
			pauseMenu.open()
			pauseMenu.visible = true
			
	gameState = newState


func _on_press_start():
	sceneInstance = load(gameScenePath).instantiate()
	$Main3D.add_child(sceneInstance)
	set_state(Enums.GameState.IN_GAME)
	$titleAudioLoop.stop()


func _on_press_resume():
	set_state(Enums.GameState.IN_GAME)
	get_tree().paused = false


func _on_press_quit():
	set_state(Enums.GameState.ON_START)
	if (is_instance_valid(sceneInstance)):
		sceneInstance.queue_free()
	sceneInstance = null
	get_tree().paused = false
