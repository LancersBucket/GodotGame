extends CanvasLayer

var time = 400
var score = 0
var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	while time > 0:
		$Time.text = "TIME\n " + str(time)
		time -= 1
		await get_tree().create_timer(.5).timeout
	get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Coins.text = "x" + "%02d" % coins 
