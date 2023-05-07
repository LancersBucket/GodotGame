extends RigidBody2D

@onready var player = $"/root/Main/Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		gravity_scale = .5

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player.playerState = player.States.STUN
		player.stunTimer = player.stunTimerLength
		player.velocity = Vector2(0,0)
