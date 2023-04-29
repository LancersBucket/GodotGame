extends CharacterBody2D

@export var run_speed = 175
@export var walk_speed = 100
@export var jump_speed = -350.0

var screen_size # Size of the game window
var gravity = 980

@onready var camera = $"../Camera"

var timer = 7
var facing = 1
var acceleration = 3
var friction = 0.1
var lives = 3

const NORMAL = Vector2(0,-1)
const RIGHT = 1
const LEFT = -1

func _ready():
	screen_size = get_viewport_rect().size
	
func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta
	
	if !is_on_floor():
		timer -= 1
	else:
		timer = 7
	
	# Handle Jump.
	if Input.is_action_just_pressed("move_up") and timer >= 0:
		velocity.y = jump_speed
	
	# Get the input direction.
	var direction = Input.get_axis("move_left", "move_right")
	
	# Whole bunch of code to calculate momentum
	if (is_on_floor()):
		# If on floor and running
		if Input.is_action_pressed("run"):
			if direction == RIGHT:
				velocity.x = min(velocity.x+acceleration, run_speed)
			elif direction == LEFT:
				velocity.x = max(velocity.x-acceleration, -run_speed)
			else:
				# Slowly brings velocity to zero if not touching anything
				velocity.x = lerp(velocity.x, 0.0, friction)
		# If on floor and walking
		elif !Input.is_action_pressed("run"):
			# If speed is > walk_speed decelerate to walk_speed 
			if (velocity.x > walk_speed+10):
				velocity.x = lerp(velocity.x, float(walk_speed), friction)
			else:
				if direction == RIGHT:
					velocity.x = min(velocity.x+acceleration, walk_speed)
				elif direction == LEFT:
					velocity.x = max(velocity.x-acceleration, -walk_speed)
				else:
					# Slowly brings velocity to zero if not touching anything
					velocity.x = lerp(velocity.x, 0.0, friction)
	elif !is_on_floor():
		# If not on floor and running
		if Input.is_action_pressed("run"):
			if direction == RIGHT:
				velocity.x = min(velocity.x+(acceleration/2.0), run_speed)
			elif direction == LEFT:
				velocity.x = max(velocity.x-(acceleration/2.0), -run_speed)
		# If not on floor and walking
		elif !Input.is_action_pressed("run"):
			if velocity.x < walk_speed:
				if direction == RIGHT:
					velocity.x = min(velocity.x+(acceleration/2.0), walk_speed)
				elif direction == LEFT:
					velocity.x = max(velocity.x-(acceleration/2.0), -walk_speed)
	
	# If your running enable higher jumps
	if (Input.is_action_pressed("run") && is_on_floor() && velocity.x > walk_speed):
		jump_speed = -375
	else:
		jump_speed = -350
	
	# Prevents direction from going 0 and setting velocity.x instantly to 0
	if is_on_floor():
		if direction == LEFT:
			facing = LEFT
		elif direction == RIGHT:
			facing = RIGHT
	
	move_and_slide()
	
	# Clamps player position to stay on screen
	position.x = maxf(position.x, camera.position.x-(screen_size.x/2)-24)
	
	
	# Animation
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.x != 0 && abs(velocity.x) > 15 :
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.play("idle")
	# Camera position code. Sets camera to player x except when player is behind camera x
	if (position.x > camera.position.x):
		camera.position.x = position.x
		
	
func start(pos):
	position = pos
	
func clampNum(_num, _min, _max):
	_num = minf(maxf(_num, _min), _max)
	
func die():
	lives -= 1
	get_tree().change_scene_to_file("res://info_screen.tscn")
