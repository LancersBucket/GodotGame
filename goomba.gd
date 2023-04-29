extends CharacterBody2D
@onready var player = $"/root/Main/Player"

const SPEED = 30.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isOnScreen = 0
var alive = 1
var x = 0
var direction = -1
var cooldown = 0

func _physics_process(delta):
	if isOnScreen && alive:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		if is_on_wall() && cooldown == 0:
			direction *= -1
			cooldown = 2
		
		if cooldown > 0:
			cooldown -= 1
			
		velocity.x = direction * SPEED
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.play("walk")

		move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_entered():
	isOnScreen = 1

func die():
	$AnimatedSprite2D.animation = "die"
	$AnimatedSprite2D.play("die")
	get_node("CollisionShape2D").set_deferred("disabled",true)
	get_node("Area2D/CollisionShape2D2").set_deferred("disabled",true)
	
	$"/root/Main/HUD".score += 100
	
	alive = 0
	
	await get_tree().create_timer(.5).timeout
	queue_free()
	

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		if player.velocity.y > 0:
			die()
			player.velocity.y = -200
		else:
			get_tree().reload_current_scene()

