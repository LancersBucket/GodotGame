extends Node

@onready var player = $Player
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD.running = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
