extends Area2D

func _physics_process(delta):
	position.x += -150 * delta


func _on_body_entered(body):
	$powerupy.play()
	hide()
	body.hasPowerUp = true
