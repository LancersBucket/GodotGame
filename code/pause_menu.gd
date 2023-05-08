extends ColorRect

@onready var resume = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Resume
@onready var exit = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Exit
@onready var animator: AnimationPlayer = $AnimationPlayer

func _ready():
	resume.pressed.connect(unpause)
	exit.pressed.connect(get_tree().quit)

func unpause():
	animator.play("Unpause")
	get_tree().paused = false

func pause():
	animator.play("Pause")
	get_tree().paused = true
