extends CharacterBody2D

@export var run_speed = 150
@export var walk_speed = 50
@export var jump_speed = -350.0

#980 default
var gravity = 980.0/2.0 

@onready var camera = $"../Camera"

var actual_speed = walk_speed


func _physics_process(delta):
	
	# Add the gravity.
	velocity.y += gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("move_up") and is_on_floor():
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
	print(actual_speed)
	
	# Arcane code
	actual_speed = minf(maxf(actual_speed, walk_speed), run_speed)
	
	#print(actual_speed)
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
		
	#camera.position.y = 0
	camera.position.x = position.x
	#camera.global_translate(velocity)
	
func start(pos):
	position = pos
	
	
