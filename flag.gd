extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		$"/root/Main/Player".playerControl = false;
		$Area2D/CollisionShape2D.set_deferred("disabled",true)
		endGame()
		
func endGame():
	await get_tree().create_timer(.5).timeout
	$"/root/Main/Player".flagControl = true;
