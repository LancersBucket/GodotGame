extends CharacterBody2D

@onready var player = $"/root/Main/Player"

enum STATE { IDLE, WALK, LOOK, NULL }

const SPEED = 75.0

var direction = -1
var timerLength = 225
var idleLength = 50 
var walkContinue = 75
var timer = idleLength
var currentState = STATE.IDLE

func _physics_process(delta):
	timer -= 1
	
	# Flip for facing left first
	if (direction < 0):
		$AnimatedSprite2D.flip_h = false
	elif (direction > 0):
		$AnimatedSprite2D.flip_h = true
		
	if (currentState == STATE.IDLE):
		if (timer <= 0):
			direction *= -1
			# Runs if equal to 1
			if (randi_range(1,3) == 1):
				currentState = STATE.LOOK
				direction *= -1
			else:
				currentState = STATE.WALK
				timer = timerLength
				
		# Animation
		$AnimatedSprite2D.play("idle")
	
	elif (currentState == STATE.WALK):
		if (timer <= 0):
			# Runs if equal to 1
			if (randi_range(1,3) == 1):
				currentState = STATE.WALK
				timer = walkContinue
			else:
				currentState = STATE.IDLE
				timer = idleLength
		
		# Control
		velocity.x = direction * SPEED
		move_and_slide()
		
		# Animation
		$AnimatedSprite2D.play("walk")
		
	elif (currentState == STATE.LOOK):
		$AnimatedSprite2D.play("look")
		
func _on_animated_sprite_2d_animation_finished():
	if ($AnimatedSprite2D.animation == "look"):
		currentState = STATE.NULL
		$AnimatedSprite2D.play("idle")
		await get_tree().create_timer(.5).timeout
		currentState = STATE.WALK
		timer = walkContinue
