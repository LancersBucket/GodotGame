extends CharacterBody2D

@onready var camera = $"/root/Main/Camera"

@export var walkSpeed = 100
@export var jumpSpeed = -350.0

enum States {PLAYER_CONTROL, STUN, DELAY}
enum MovementStates {NORMAL, WALL_JUMP, WALL_GRAB}

const NORMAL = Vector2(0,-1)
const RIGHT = 1
const LEFT = -1

var screenSize
var gravity = 980
var sneakSpeed = walkSpeed/2.0
var wallSlideGravity = gravity/8.0
var graceTimer = 7
var playerState = States.PLAYER_CONTROL
var movementState = MovementStates.NORMAL
var stunTimerLength = 200
var stunTimer = stunTimerLength
var facing = RIGHT


func _ready():
	# Gets screen size
	screenSize = get_viewport_rect().size
	
func _physics_process(delta):
	# Checks if the current state is PLAYER_CONTROL
	if (playerState == States.PLAYER_CONTROL):
		# Gravity
		velocity.y += gravity * delta
		
		# Player jump grace period
		if !is_on_floor(): graceTimer -= 1
		else: graceTimer = 7
		
		# Handle jump
		if Input.is_action_just_pressed("move_up") and graceTimer >= 0:
			velocity.y = jumpSpeed
			var jumpChoice = randi_range(1,3)
			#randomizes jump sound
			if jumpChoice == 1:
				$"JumpSFX".play()
			elif jumpChoice == 2:
				$"Jump2SFX".play()
			elif jumpChoice == 3:
				$"Jump3SFX".play()
		# Handle wall jump
		elif Input.is_action_just_pressed("move_up") and is_on_wall_only():
			velocity.y = jumpSpeed
			velocity.x = walkSpeed*-facing
			# Transitions to WALL_JUMP state and locks movement until player hits the floor
			#randomizes jump sound
			var jumpChoice = randi_range(1,3)
			if jumpChoice == 1:
				$"JumpSFX".play()
			elif jumpChoice == 2:
				$"Jump2SFX".play()
			elif jumpChoice == 3:
				$"Jump3SFX".play()
			movementState = MovementStates.WALL_JUMP
			
		# Get the input direction
		var direction = Input.get_axis("move_left", "move_right")

		# Movement speed
		if (!$Sight.is_colliding() and $Touch.is_colliding() and velocity.y > 0 and !is_on_floor()):
			movementState = MovementStates.WALL_GRAB
			velocity = Vector2(0,0)
		
		# Movement
		if (movementState == MovementStates.NORMAL):
			# Checks for wall slide
			if (is_on_wall_only()):
				velocity.y = min(wallSlideGravity, velocity.y)
			# Sneaking
			if (!Input.is_action_pressed("run")):
				velocity.x = walkSpeed*direction
			# Normal speed
			else:
				velocity.x = sneakSpeed*direction
		# Wall jump "movement"
		elif (movementState == MovementStates.WALL_JUMP):
			# Blocks movement until player hits the floor again
			if (is_on_floor()):
				$Sight.set_deferred("disabled",false)
				$Touch.set_deferred("disabled",false)
				movementState = MovementStates.NORMAL
		elif (movementState == MovementStates.WALL_GRAB):
			if (Input.is_action_just_pressed("move_up")):
				$Sight.set_deferred("disabled",true)
				$Touch.set_deferred("disabled",true)
				velocity.y = jumpSpeed
				velocity.x = walkSpeed*-facing
				movementState = MovementStates.WALL_JUMP
			
		
		# Some code for wall jump movement and direction detection so it doesn't fall to 0 breaking code
		if direction == RIGHT:
			facing = RIGHT
			$Sight.target_position.x = 16
			#$Sight.position.y = -15
			
			$Touch.target_position.x = 16
			#$Touch.position.y = -5
		elif direction == LEFT:
			facing = LEFT
			$Sight.target_position.x = -16
			#$Sight.position.y = -15
			
			$Touch.target_position.x = -16
			#$Touch.position.y = -4
		
		move_and_slide()
		
		
		# Clamps player position to stay on screen
		position.x = maxf(position.x, camera.position.x-(screenSize.x/2)-24)
		
		# Animation
		if (movementState == MovementStates.NORMAL):
			if velocity.y < 0:
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.flip_h = -min(0,facing)
				$AnimatedSprite2D.animation = "up"
				$"ScamperingSFX".stop()
			elif velocity.y > 0:
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.flip_h = -min(0,facing)
				$AnimatedSprite2D.animation = "down"
				$"ScamperingSFX".stop()
			elif velocity.x != 0:
				if !$"ScamperingSFX".playing:
					$"ScamperingSFX".play()
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.flip_h = -min(0,facing)
				$AnimatedSprite2D.play("walk") 
			else:
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.play("idle")
				$"ScamperingSFX".stop()
	
	# Stun state
	elif (playerState == States.STUN):
		# Checks if on floor and if is set velocity.x to 0 and start decreasing stun timer
		if (is_on_floor() && stunTimer <= stunTimerLength-1):
			velocity.x = 0
			stunTimer -= 1
		# Initial stun momentum
		if (stunTimer == stunTimerLength):
			$"HurtSFX".play()
			velocity.y = jumpSpeed
			velocity.x = walkSpeed*-facing
			stunTimer -= 1
		# If stun timer is 0 reset stun timer
		elif (stunTimer <= 0):
			stunTimer = stunTimerLength
			playerState = States.PLAYER_CONTROL
		
		# Normal gravity and movement
		velocity.y += gravity * delta
		move_and_slide()
		
	# Camera position code. Sets camera to player x except when player is behind camera x
	camera.position.x = position.x
	camera.position.y = position.y
	
func die():
	get_tree().change_scene_to_file("res://scenes/info_screen.tscn")
