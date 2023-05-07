extends CharacterBody2D

@onready var camera = $"/root/Main/Camera"

@export var walk_speed = 100
@export var jump_speed = -350.0

enum States {PLAYER_CONTROL, STUN}
enum MovementStates {NORMAL, WALL_JUMP, WALL_GRAB}

const NORMAL = Vector2(0,-1)
const RIGHT = 1
const LEFT = -1

var screen_size
var gravity = 980
var sneak_speed = walk_speed/2.0
var wallSlideGravity = gravity/8.0
var graceTimer = 7
var playerState = States.PLAYER_CONTROL
var movementState = MovementStates.NORMAL
var stunTimerLength = 200
var stunTimer = stunTimerLength
var facing = RIGHT


func _ready():
	# Gets screen size
	screen_size = get_viewport_rect().size
	
func _physics_process(delta):
	# Checks if the current state is PLAYER_CONTROL
	if (playerState == States.PLAYER_CONTROL):
		# Gravity
		velocity.y += gravity * delta
		
		# Player jump grace period
		if !is_on_floor(): graceTimer -= 1
		else: graceTimer = 7
		
		# Handle jump
		if Input.is_action_just_pressed("move_up") and graceTimer >= 0:
			velocity.y = jump_speed
			$"JumpSFX".play()
		# Handle wall jump
		elif Input.is_action_just_pressed("move_up") and is_on_wall_only():
			velocity.y = jump_speed
			velocity.x = walk_speed*-facing
			# Transitions to WALL_JUMP state and locks movement until player hits the floor
			$"JumpSFX".play()
			movementState = MovementStates.WALL_JUMP
			
		# Get the input direction
		var direction = Input.get_axis("move_left", "move_right")
			
		# Movement
		if (movementState == MovementStates.NORMAL):
			# Checks for wall slide
			if (is_on_wall_only()):
				velocity.y = min(wallSlideGravity, velocity.y)
			# Sneaking
			if (!Input.is_action_pressed("run")):
				velocity.x = walk_speed*direction
			# Normal speed
			else:
				velocity.x = sneak_speed*direction
		# Wall jump "movement"
		elif (movementState == MovementStates.WALL_JUMP):
			# Blocks movement until player hits the floor again
			if (is_on_floor()):
				movementState = MovementStates.NORMAL
		
		# Some code for wall jump movement and direction detection so it doesn't fall to 0 breaking code
		if direction == RIGHT:
			facing = RIGHT
		elif direction == LEFT:
			facing = LEFT
		
		move_and_slide()
		
		
		# Clamps player position to stay on screen
		position.x = maxf(position.x, camera.position.x-(screen_size.x/2)-24)
		
		# Animation
		if velocity.y < 0:
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = -min(0,facing)
			$AnimatedSprite2D.animation = "up"
		elif velocity.y > 0:
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = -min(0,facing)
			$AnimatedSprite2D.animation = "down"
		elif velocity.x != 0:
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = -min(0,facing)
			$AnimatedSprite2D.play("walk") 
		else:
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.play("idle")
	
	# Stun state
	elif (playerState == States.STUN):
		# Checks if on floor and if is set velocity.x to 0 and start decreasing stun timer
		if (is_on_floor() && stunTimer <= stunTimerLength-1):
			velocity.x = 0
			stunTimer -= 1
		# Initial stun momentum
		if (stunTimer == stunTimerLength):
			$"HurtSFX".play()
			velocity.y = jump_speed
			velocity.x = walk_speed*-facing
			stunTimer -= 1
		# If stun timer is 0 reset stun timer
		elif (stunTimer <= 0):
			stunTimer = stunTimerLength
			playerState = States.PLAYER_CONTROL
		
		# Normal gravity and movement
		velocity.y += gravity * delta
		move_and_slide()
		
		
	# Camera position code. Sets camera to player x except when player is behind camera x
	camera.position.x = position.x
	camera.position.y = position.y
	
func die():
	get_tree().change_scene_to_file("res://scenes/info_screen.tscn")
