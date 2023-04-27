extends CharacterBody2D

@export var speed = 400 # How fast the player will move (pixels/sec)

# Called when the node enters the scene tree for the first time.
func _ready():
	#hide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_up")
	)
	
	velocity = input_direction * speed
		
	move_and_slide()
	
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	else:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.flip_v = false

	
func start(pos):
	position = pos
	
