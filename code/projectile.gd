extends StaticBody2D

@onready var player = $"/root/Main/Player"
var speed = .5
var falling = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (falling):
		var temp = move_and_collide(Vector2(0,speed))

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		if (falling):
			player.playerState = player.States.STUN
			player.stunTimer = player.stunTimerLength
	if body.is_in_group("static"):
		falling = false
		$DespawnTimer.wait_time = $"/root/Main/Falling Object Controller".DespawnTimer
		$DespawnTimer.start()



func _on_despawn_timer_timeout():
	queue_free()
