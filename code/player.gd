extends CharacterBody2D

@onready var camera = $"/root/Main/Camera"

@export var walkSpeed = 100
@export var jumpSpeed = -350.0
@export var cameraOffsety = 30

enum States {PLAYER_CONTROL, STUN, CLIMB}
enum MovementStates {NORMAL, WALL_JUMP, WALL_GRAB, WALL_SLIDE}

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
var stunTimerLength = 50
var stunTimer = stunTimerLength
var facing = RIGHT
var wallJumpGraceLength = 5
var wallJumpGrace = wallJumpGraceLength




func _ready():
	# Gets screen size
	screenSize = get_viewport_rect().size
	
func _physics_process(delta):
	
	if Input.is_action_just_pressed("menu"):
		$PauseMenu.pause()

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
			
			#randomizes jump sound
			get_node("Jump"+str(randi_range(1,3))+"SFX").play()
			
			
		# Get the input direction
		var direction = Input.get_axis("move_left", "move_right")
		
		
		#Condition checks for wall slide, would not work in condition below
		if (is_on_wall_only()):
			if (!$"SlidingSFX".playing && velocity.y > 0 && movementState != MovementStates.WALL_GRAB):
				$"SlidingSFX".play()
				movementState = MovementStates.WALL_SLIDE
		else:
			$"SlidingSFX".stop()
			
		# Movement
		if (movementState == MovementStates.NORMAL):
			# Sneaking
			if (!Input.is_action_pressed("run")):
				velocity.x = walkSpeed*direction
			# Normal speed
			else:
				velocity.x = sneakSpeed*direction
				
			# Wall grab check
			if (!$Sight.is_colliding() and $Touch.is_colliding() and velocity.y > 0 and !is_on_floor()):
				$"SlidingSFX".stop()
				movementState = MovementStates.WALL_GRAB
				$Sight.set_deferred("disabled",true)
				$Touch.set_deferred("disabled",true)
				velocity = Vector2(0,0)
		elif (movementState == MovementStates.WALL_SLIDE):
			velocity.y = min(wallSlideGravity, velocity.y)
			
			if (!$"SlidingSFX".playing):
				$"SlidingSFX".play()
			
			wallJumpGrace -= 1
			
			if (Input.is_action_just_pressed("move_up")):# && wallJumpGrace < 0):
				velocity.x = walkSpeed*-facing
				velocity.y = jumpSpeed
				facing = -facing
				$AnimatedSprite2D.flip_h = -min(0,facing)
				$AnimatedSprite2D.animation = "up"
				#randomizes jump sound
				get_node("Jump"+str(randi_range(1,3))+"SFX").play()
				
				# Transitions to WALL_JUMP state and locks movement until player hits the floor
				movementState = MovementStates.WALL_JUMP
				wallJumpGrace = wallJumpGraceLength
			elif (facing == LEFT && Input.is_action_just_pressed("move_right") && wallJumpGrace < 0):
				movementState = MovementStates.NORMAL
				wallJumpGrace = wallJumpGraceLength
			elif (facing == RIGHT && Input.is_action_just_pressed("move_left") && wallJumpGrace < 0):
				movementState = MovementStates.NORMAL
				wallJumpGrace = wallJumpGraceLength
			
			if (is_on_floor()):
				movementState = MovementStates.NORMAL
				wallJumpGrace = wallJumpGraceLength
			if(!$Sight.is_colliding() and !$Touch.is_colliding() && wallJumpGrace < 0):
				print("here")
				movementState = MovementStates.NORMAL
				wallJumpGrace = wallJumpGraceLength
			
					
		# Wall jump "movement"
		elif (movementState == MovementStates.WALL_JUMP):
			if (is_on_floor()):
				$Sight.set_deferred("disabled",false)
				$Touch.set_deferred("disabled",false)
				movementState = MovementStates.NORMAL
			if (is_on_wall_only()):
				movementState = MovementStates.WALL_SLIDE
			
		elif (movementState == MovementStates.WALL_GRAB):
			velocity.y = 0
			if (Input.is_action_pressed("move_up")):
				get_node("Jump"+str(randi_range(1,3))+"SFX").play()
				$Sight.set_deferred("disabled",true)
				$Touch.set_deferred("disabled",true)
				velocity.y = jumpSpeed
				velocity.x = walkSpeed*-facing
				movementState = MovementStates.WALL_JUMP
			elif Input.is_action_pressed("move_down"):
				movementState = MovementStates.NORMAL
			elif (Input.is_action_pressed("move_left")):
				if (facing == LEFT):
					playerState = States.CLIMB
				else:
					movementState = MovementStates.NORMAL
			elif (Input.is_action_pressed("move_right")):
				if (facing == RIGHT):
					playerState = States.CLIMB
				else:
					movementState = MovementStates.NORMAL
		
		# Some code for wall jump movement and direction detection so it doesn't fall to 0 breaking code
		if (movementState != MovementStates.WALL_JUMP):
			if direction == RIGHT:
				facing = RIGHT
			elif direction == LEFT:
				facing = LEFT
			$Sight.target_position.x = 16*facing
			$Touch.target_position.x = 16*facing
		
		move_and_slide()
		
		
		# Clamps player position to stay on screen
		position.x = maxf(position.x, camera.position.x-(screenSize.x/2)-24)
		
		# Animation
		if (movementState == MovementStates.NORMAL):
			if velocity.y < 0:
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.flip_h = -min(0,facing)
				$AnimatedSprite2D.animation = "up"
				$"Scampering1SFX".stop()
				$"Scampering2SFX".stop()
				$"Scampering3SFX".stop()
			elif velocity.y > 0:
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.flip_h = -min(0,facing)
				$AnimatedSprite2D.animation = "down"
					
				$"Scampering1SFX".stop()
				$"Scampering2SFX".stop()
				$"Scampering3SFX".stop()
			elif velocity.x != 0:
				if !$"Scampering1SFX".playing && !$"Scampering2SFX".playing && !$"Scampering3SFX".playing:
					get_node("Scampering"+str(randi_range(1,3))+"SFX").play()
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.flip_h = -min(0,facing)
				$AnimatedSprite2D.play("walk") 
			else:
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.play("idle")
				$"Scampering1SFX".stop()
				$"Scampering2SFX".stop()
				$"Scampering3SFX".stop()
		if (movementState == MovementStates.WALL_SLIDE):
			if (velocity.y > 0 && wallJumpGrace < 0):
				$AnimatedSprite2D.animation = "wall grab"
	
	# Stun state
	elif (playerState == States.STUN):
		# Checks if on floor and if is set velocity.x to 0 and start decreasing stun timer
		$AnimatedSprite2D.animation = "stun"
		if (is_on_floor() && stunTimer <= stunTimerLength-1):
			$AnimatedSprite2D.animation = "stun grounded"
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
		
	elif (playerState == States.CLIMB):
		$AnimatedSprite2D.play("ledge jump up")
	
	# Camera position code.
	camera.position.x = position.x
	camera.position.y = position.y - cameraOffsety
	
func die():
	get_tree().change_scene_to_file("res://scenes/info_screen.tscn")

func _on_animated_sprite_2d_animation_finished():
	#climb playerstate
	if $AnimatedSprite2D.animation == "ledge jump up":
		if (facing == RIGHT):
			position.x += 16*facing
			position.y -= 32
			playerState = States.PLAYER_CONTROL
			movementState = MovementStates.NORMAL
		elif (facing == LEFT):
			position.x += 16*facing
			position.y -= 32
			playerState = States.PLAYER_CONTROL
			movementState = MovementStates.NORMAL
