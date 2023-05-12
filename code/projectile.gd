extends StaticBody2D

@onready var player = $"/root/Main/Player"

@export var fadeOutTime = 30.0
# 0 is reguler, 1 is fall and regenerate
@export_range(0,1,1) var mode = 0
@export var fallingSpeed = .5
#@export var respawnDelayTime = 0

var falling = true
var delete = false
var deleteFade = fadeOutTime
var previousPos
var previousSpeed

# Called when the node enters the scene tree for the first time.
func _ready():
	previousPos = position
	previousSpeed = fallingSpeed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (falling):
		# Moves the object
		var temp = move_and_collide(Vector2(0,fallingSpeed))
	if (delete):
		# If in delete mode, start fading to invisible
		deleteFade -= 1
		# Fades obj
		modulate = Color(1, 1, 1, deleteFade/fadeOutTime)
	if (deleteFade <= 0):
		# If mode == 0, delete the object
		if (!mode):
			queue_free()
		# If mode == 1, instead reset object pos to starting
		else:
			# Ignore this code, this is left over from a failed control
			#if (respawnDelayTime > 0):
			#	await get_tree().create_timer(respawnDelayTime).timeout
			#	position = previousPos
			#	modulate = Color(1, 1, 1, 1)
			#	falling = true
			#	delete = false
			#	deleteFade = fadeOutTime
			#else:
			# Resets all object data
			position = previousPos
			modulate = Color(1, 1, 1, 1)
			falling = true
			delete = false
			deleteFade = fadeOutTime
	# If player has control, enable interaction
	if (player.playerState == player.States.PLAYER_CONTROL):
		set_collision_layer_value(3,true)
		set_collision_mask_value(3,true)

func _on_area_2d_body_entered(body):
	# If stun zone collides with player and is falling, stun player and disable interaction with player
	if body.is_in_group("Player"):
		if (falling):
			player.playerState = player.States.STUN
			player.stunTimer = player.stunTimerLength
			set_collision_layer_value(3,false)
			set_collision_mask_value(3,false)
			set_collision_layer_value(1,false)
			set_collision_mask_value(1,false)
		# Return interaction when player is in non stun state
		if (player.playerState != player.States.STUN):
			set_collision_layer_value(3,true)
			set_collision_mask_value(3,true)
	# If colliding with ground, stop falling and start to despawn
	if body.is_in_group("static"):
		falling = false
		set_collision_layer_value(1,true)
		set_collision_mask_value(1,true)
		$DespawnTimer.start()

func _on_despawn_timer_timeout():
	delete = true
