extends CanvasLayer

var min = 6
var sec = 0
var score = 0
var coins = 0
var running = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	while sec >= 0 && min > 0:
		$Time.text = "TIME\n " + str(min) + ":" + str("%02d" % sec)
		if (sec > 0):
			sec -= 1
		elif (sec == 0):
			sec = 59
			min -= 1
		await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Coins.text = "x" + "%02d" % coins 
