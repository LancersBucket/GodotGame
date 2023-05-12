extends ColorRect

@onready var resume = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Resume
@onready var exit = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Exit
@onready var animator: AnimationPlayer = $AnimationPlayer


func playSound():
	$"BeepSFX".play()
func _ready():
	resume.pressed.connect(unpause)
	exit.pressed.connect(get_tree().quit)
	resume.mouse_entered.connect(playSound)
	exit.mouse_entered.connect(playSound)

func unpause():
	$"Beep2SFX".play()
	$"BeepSFX".stop()
	animator.play("Unpause")
	get_tree().paused = false
	$"Beep2SFX".stop()

func pause():
	$"BeepSFX".stop()
	$"Beep2SFX".stop()
	$"Beep2SFX".play()
	animator.play("Pause")
	get_tree().paused = true
