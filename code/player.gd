extends CharacterBody2D

@onready var camera = $"../Camera"

@export var walk_speed = 100
@export var sneak_speed = walk_speed/2.0
@export var jump_speed = -350.0

enum States {PLAYER_CONTROL, STUN}
enum MovementStates {NORMAL, WALL_JUMP, WALL_GRAB}
const NORMAL = Vector2(0,-1)
const RIGHT = 1
const LEFT = -1

var screen_size
var gravity = 980
var wallSlideGravity = gravity/8.0
var graceTimer = 7
var lives = 3
var playerState = States.PLAYER_CONTROL
var movementState = MovementStates.NORMAL
var stunTimerLength = 200
var stunTimer = stunTimerLength
var facing = RIGHT


func _ready():
	screen_size = get_viewport_rect().size
	
func _physics_process(delta):
	if (playerState == States.PLAYER_CONTROL):
		# Gravity
		velocity.y += gravity * delta
		
		# Player jump grace period
		if !is_on_floor(): graceTimer -= 1
		else: graceTimer = 7
		
		# Handle jump
		if Input.is_action_just_pressed("move_up") and graceTimer >= 0:
			velocity.y = jump_speed
			#$"JumpSFX".play()
		elif Input.is_action_just_pressed("move_up") and is_on_wall_only():
			velocity.y = jump_speed
			velocity.x = walk_speed*facing
			movementState = MovementStates.WALL_JUMP
			
		# Get the input direction
		var direction = Input.get_axis("move_left", "move_right")
			
		# Movement speed
		if (movementState == MovementStates.NORMAL):
			if (is_on_wall_only()):
				velocity.y = min(wallSlideGravity, velocity.y)
			if (!Input.is_action_pressed("run")):
				velocity.x = walk_speed*direction
			else:
				velocity.x = sneak_speed*direction
		elif (movementState == MovementStates.WALL_JUMP):
			if (is_on_floor()):
				movementState = MovementStates.NORMAL
		
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
			
	if (playerState == States.STUN):
		if (is_on_floor() && stunTimer <= stunTimerLength-1):
			velocity.x = 0
			stunTimer -= 1
		if (stunTimer == stunTimerLength):
			velocity.y = jump_speed
			velocity.x = walk_speed*-facing
			stunTimer -= 1
		elif (stunTimer <= 0):
			stunTimer = stunTimerLength
			playerState = States.PLAYER_CONTROL
		
		velocity.y += gravity * delta
		print(stunTimer)
		move_and_slide()
		
		
	# Camera position code. Sets camera to player x except when player is behind camera x
	#if (position.x > camera.position.x):
	camera.position.x = position.x
	camera.position.y = position.y
	
func die():
	lives -= 1
	get_tree().change_scene_to_file("res://scenes/info_screen.tscn")
