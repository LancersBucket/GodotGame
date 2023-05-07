extends Control

var lives = 3;

# Called when the node enters the scene tree for the first time.
func _ready():
<<<<<<< HEAD:info_screen.gd
	$Lives.text = str(lives)
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://main.tscn")
	
=======
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")
>>>>>>> 34bd293dbb81a856809c29099071f36c62484d7f:code/info_screen.gd


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
