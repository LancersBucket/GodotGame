extends CharacterBody2D

enum STATE { IDLE, WALK, LOOK }

@onready var player = $"/root/Main/Player"

const SPEED = 75.0
var direction = -1
var timer = 50
var looking = true
var lookingCooldown = 250

var currentState = STATE.IDLE

func _physics_process(delta):

	timer -= 1
	lookingCooldown -= 1
	
	if (timer <= 0):
		var choice = randi_range(1,3)
		if (choice == 1 && lookingCooldown <= 0):
			looking = true
		pick_new_state()
	if (currentState == STATE.WALK):
		move_and_slide()

	# flip for facing left first
	if (direction < 0):
		$AnimatedSprite2D.flip_h = false
	elif (direction > 0):
		$AnimatedSprite2D.flip_h = true

func pick_new_state():
	if (currentState == STATE.IDLE):
		currentState = STATE.WALK
		direction *= -1
		timer = 50
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("walk")
	elif (currentState == STATE.WALK):
		currentState = STATE.IDLE
		timer = 50
		$AnimatedSprite2D.play("idle")
	elif (currentState == STATE.LOOK):
		$AnimatedSprite2D.play("look")
		
func _on_animated_sprite_2d_animation_finished():
	if ($AnimatedSprite2D.animation == "look"):
		currentState = STATE.WALK
		lookingCooldown = 250
