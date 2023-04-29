extends CanvasLayer

var time = 399
var score = 0
var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	while time > 0:
		time -= 1
		$Time.text = "TIME\n " + str(time)
		await get_tree().create_timer(.5).timeout
	get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Score.text = "MARIO\n" + "%06d" % score
	$Coins.text = "x" + str(coins); 
