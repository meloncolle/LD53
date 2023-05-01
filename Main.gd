extends Node

enum GameState {ON_START, IN_GAME, PAUSED}

var gameState: GameState
var gameScenePath: String = "res://Levels/Test3D/test_lvl_3d.tscn"
var sceneInstance: Node = null

@onready var startMenu: Control = $CanvasLayer/StartMenu
@onready var pauseMenu: Control = $CanvasLayer/PauseMenu

func _ready():
	set_state(GameState.ON_START)
	startMenu.get_node("Panel/StartButton").pressed.connect(self._on_press_start)
	pauseMenu.get_node("Panel/VBoxContainer/ResumeButton").pressed.connect(self._on_press_resume)
	pauseMenu.get_node("Panel/VBoxContainer/QuitButton").pressed.connect(self._on_press_quit)
	$titleAudioLoop.play()


func _input (event: InputEvent):
	if(gameState != GameState.ON_START && event.is_action_pressed("ui_cancel")):
		get_tree().paused = !get_tree().paused
		
		match gameState:
			GameState.IN_GAME:
				set_state(GameState.PAUSED)
				
			GameState.PAUSED:
				set_state(GameState.IN_GAME)
	
func set_state(newState: GameState):
	match newState:
		GameState.ON_START:
			startMenu.visible = true
			pauseMenu.visible = false
			
		GameState.IN_GAME:
			startMenu.visible = false
			pauseMenu.visible = false
			
		GameState.PAUSED:
			pauseMenu.visible = true
			
	gameState = newState


func _on_press_start():
	sceneInstance = load(gameScenePath).instantiate()
	$Main3D.add_child(sceneInstance)
	set_state(GameState.IN_GAME)
	$titleAudioLoop.stop()
	
func _on_press_resume():
	get_tree().paused = false
	set_state(GameState.IN_GAME)
	
func _on_press_quit():
	if (is_instance_valid(sceneInstance)):
		sceneInstance.queue_free()
	sceneInstance = null
	get_tree().paused = false
	set_state(GameState.ON_START)
