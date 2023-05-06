extends CharacterBody2D

@onready var camera = $"../Camera"

@export var walk_speed = 100
@export var sneak_speed = walk_speed/2.0
@export var jump_speed = -350.0

enum States {PLAYER_CONTROL}
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
			velocity.x = -walk_speed
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
		
		move_and_slide()
		
		
		# Clamps player position to stay on screen
		position.x = maxf(position.x, camera.position.x-(screen_size.x/2)-24)
		
		# Animation
		if velocity.y < 0:
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
			$AnimatedSprite2D.animation = "up"
		elif velocity.y > 0:
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
			$AnimatedSprite2D.animation = "down"
		elif velocity.x != 0:
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
			$AnimatedSprite2D.play("walk") 
		else:
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.play("idle")
		
	# Camera position code. Sets camera to player x except when player is behind camera x
	#if (position.x > camera.position.x):
	camera.position.x = position.x
	camera.position.y = position.y
	
func die():
	lives -= 1
	get_tree().change_scene_to_file("res://scenes/info_screen.tscn")
