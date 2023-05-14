extends ColorRect

@onready var resume = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Resume
#@onready var exit = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Exit
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var paused = false
func playSound():
	if paused:
		$"BeepSFX".play()
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#exit.disabled = true
	resume.pressed.connect(unpause)
	#exit.pressed.connect(get_tree().quit)
	resume.mouse_entered.connect(playSound)
	#exit.mouse_entered.connect(playSound)

func unpause():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	paused = false
	$"BeepSFX".stop()
	animator.play("Unpause")
	get_tree().paused = false
	#exit.disabled = true
	$/root/Main/AudioStreamPlayer.stream_paused = false

func pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	paused = true
	$"BeepSFX".stop()
	$"Beep2SFX".stop()
	$"Beep2SFX".play()
	animator.play("Pause")
	get_tree().paused = true
	#exit.disabled = false
	$/root/Main/AudioStreamPlayer.stream_paused = true
	

