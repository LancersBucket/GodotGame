extends CharacterBody2D

@onready var camera = $"../Camera"

@export var walk_speed = 100
@export var jump_speed = -350.0

enum States {PLAYER_CONTROL}
const NORMAL = Vector2(0,-1)
const RIGHT = 1
const LEFT = -1

var screen_size
var gravity = 980
var graceTimer = 7
var lives = 3
var state = States.PLAYER_CONTROL

func _ready():
	screen_size = get_viewport_rect().size
	
func _physics_process(delta):
	if (state == States.PLAYER_CONTROL):
		# Gravity
		velocity.y += gravity * delta
		
		# Player jump grace period
		if !is_on_floor(): graceTimer -= 1
		else: graceTimer = 7
		
		# Handle jump
		if Input.is_action_just_pressed("move_up") and graceTimer >= 0:
			velocity.y = jump_speed
			$"boing-boing".play()
		
		# Get the input direction
		var direction = Input.get_axis("move_left", "move_right")
		
		# Movement speed
		velocity.x = walk_speed*direction
		
		move_and_slide()
		
		# Clamps player position to stay on screen
		position.x = maxf(position.x, camera.position.x-(screen_size.x/2)-24)
		
		# Animation
		if velocity.y < 0:
			$AnimatedSprite2D.animation = "up"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
		elif velocity.y > 0:
			$AnimatedSprite2D.animation = "down"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
		elif velocity.x != 0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
			$AnimatedSprite2D.play("walk") 
		else:
			$AnimatedSprite2D.animation = "idle"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.play("idle")
		
	# Camera position code. Sets camera to player x except when player is behind camera x
	#if (position.x > camera.position.x):
	camera.position.x = position.x
	camera.position.y = position.y
	
func die():
	lives -= 1
	get_tree().change_scene_to_file("res://scenes/info_screen.tscn")
