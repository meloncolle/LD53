extends AudioStreamPlayer

@export var player:Node3D
@export var maxdb = 0.0

var fade_out:bool = false
var starting_db: float

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_db = volume_db

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fade_out && volume_db > -80.0:
		volume_db = lerp(volume_db, -80.0, delta * 0.5)
