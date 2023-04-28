extends CharacterBody2D

@export var run_speed = 200
@export var walk_speed = 100
@export var jump_speed = -350.0


var gravity = 980 

@onready var camera = $"../Camera"

var actual_speed = walk_speed
var timer = 7

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
	
	var move = 0.0
	if (Input.is_action_pressed("run")): 
		move = 5.0
	else:
		move = -5.0
		
	if velocity.x == 0:
		actual_speed -= 10
	
	actual_speed += move
	
	# Arcane code
	actual_speed = minf(maxf(actual_speed, walk_speed), run_speed)
	
	if (actual_speed > 100):
		jump_speed = -375
	else:
		jump_speed = -350
	
	velocity.x = direction * actual_speed
	
	move_and_slide()
	
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
		
	camera.position.x = position.x + 50
	
func start(pos):
	position = pos
	
	
