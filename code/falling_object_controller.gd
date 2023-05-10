extends Node2D

@export var fallingSpeedMin = 1.0
@export var fallingSpeedMax = 5.0
# In seconds
@export var spawnDelayMin = 4.0
@export var spawnDelayMax = 9.0

# Initilizes array of objects to be generated [preload("..."),preload("...")]
var objects = [
	### For every object you want to add you must use preload("filePath") or else it won't work ###
	preload("res://scenes/projectile.tscn")    # Rememeber to add the "," if adding more
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.wait_time = randf_range(spawnDelayMin, spawnDelayMax)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	# Creates a new instance of the falling scene
	var falling = objects[randi_range(0, objects.size()-1)].instantiate()
	
	# Chooses a random location on the Path2D
	var spawn_location = $Path2D/PathFollow2D
	spawn_location.progress_ratio = randf()
	
	# Set the falling's position to a random location
	falling.position = spawn_location.position
	
	# Set a random falling speed
	falling.speed = randf_range(fallingSpeedMin, fallingSpeedMax)
	
	# Spawn the falling by adding it to the main scene
	add_child(falling)
	
	$SpawnTimer.wait_time = randf_range(spawnDelayMin, spawnDelayMax)
