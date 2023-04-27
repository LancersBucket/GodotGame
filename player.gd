extends CharacterBody2D

@export var speed = 232.0
@export var jump_speed = -350.0

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var camera = $"../Camera"


func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = jump_speed
		
	# Get the input direction.
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	
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
	
	
