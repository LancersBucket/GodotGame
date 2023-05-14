extends Control

#@onready var quit = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/Quit
@onready var start = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/Start

# Called when the node enters the scene tree for the first time.
func _ready():
	#quit.pressed.connect(get_tree().quit)
	start.pressed.connect(startGame)

func startGame():
	get_tree().change_scene_to_file("res://scenes/testing.tscn")
