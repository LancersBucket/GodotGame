extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec)

# Called when the node enters the scene tree for the first time.
func _ready():
	#hide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		# velocity.normalized() is so that the player does not move faster in the diagonal direction
		# if both movements are active the movement vector would be (1,1) and normalizing it makes it
		# so that the vector length would be 1
		velocity = velocity.normalized() * speed
		# $ is shorthand for get_node() (a child of the player Area2D)
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity*delta
	
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
	
