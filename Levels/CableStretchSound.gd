extends AudioStreamPlayer

@export var player:Node3D
@export var maxdb = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	volume_db = -150.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var currentdb = lerp(-150.0, maxdb, player.wireManager.wireForce)
	volume_db = currentdb
	
	

