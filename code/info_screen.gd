extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Lives.text = "3"
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
