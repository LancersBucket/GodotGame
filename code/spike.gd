extends Node2D

@onready var player = $"/root/Main/Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	# Checks if colliding with player
	if body.is_in_group("Player"):
		# Puts player in stun state and sets velocity to 0
		player.playerState = player.States.STUN
		player.stunTimer = player.stunTimerLength
		player.velocity = Vector2(0,0)
