extends CharacterBody2D

@export var run_speed = 175
@export var walk_speed = 75
@export var jump_speed = -350.0

var screen_size # Size of the game window
var gravity = 980 

@onready var camera = $"../Camera"

var actual_speed = 0
var timer = 7
var facing = 1
var mult = 0

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
	
	
	# Whole buch of code to calculate momentum
	if (Input.is_action_pressed("run")) && direction != 0: 
		mult = 10
		actual_speed += mult
	elif direction != 0 && actual_speed > walk_speed:
		mult = -3
		actual_speed += mult
		minf(maxf(actual_speed, walk_speed), run_speed)
	elif direction != 0:
		mult = 5
		actual_speed += mult
		actual_speed = minf(maxf(actual_speed, 0), walk_speed)
	elif direction == 0:
		mult = -3
		actual_speed += mult
	
	# Arcane code (Locks speed between 0 and run_speed)
	actual_speed = minf(maxf(actual_speed, 0), run_speed)
	
	# If your running enable higher jumps
	if (actual_speed > 100):
		jump_speed = -375
	else:
		jump_speed = -350
	
	# Prevents direction from going 0 and setting velocity.x instantly to 0
	if (direction == -1):
		facing = -1
	elif direction == 1:
		facing = 1 
	velocity.x = (actual_speed*facing)
	
	move_and_slide()
	
	# Clamps player position to stay on screen
	position.x = maxf(position.x, camera.position.x-(screen_size.x/2)-24)
	#position.x = clamp(position.x, 0, camera.position.x+screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	
	# Animation
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
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
		
	# Camera position code. Sets camera to player x except when player is behind camera x
	if (position.x > camera.position.x):
		camera.position.x = position.x
		
	
func start(pos):
	position = pos
	
func clampNum(_num, _min, _max):
	_num = minf(maxf(_num, _min), _max)
