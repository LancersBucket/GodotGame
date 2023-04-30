extends Node2D

@onready var player = $"/root/Main/Player"
var timer = 5
var alert = false
var end = false
@onready var temp = $AnimatedSprite2D.offset.y - 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (alert):
		$AnimatedSprite2D.play("move")
		$AnimatedSprite2D.offset.y = temp
		#player.velocity.y = 0
		timer -= 1

func _on_area_2d_body_entered(body):
	if (!alert):
		if body.is_in_group("Player"):
			if player.velocity.y <= 0 && player.position.y > position.y:
				alert = true
			

func _on_animated_sprite_2d_animation_looped():
	if (alert):
		$AnimatedSprite2D.animation = "empty"
		$AnimatedSprite2D.offset.y = temp + 1
		alert = false
