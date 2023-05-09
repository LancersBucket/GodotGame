extends StaticBody2D

@onready var player = $"/root/Main/Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(Vector2(0,0.5))

func _on_area_2d_body_entered(body):
	print("Collide")
	if body.is_in_group("Player"):
		player.playerState = player.States.STUN
		player.stunTimer = player.stunTimerLength

