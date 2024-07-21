extends Node2D

class_name PipePair

signal bird_enterned
signal point_scored

var speed = 0 

func set_speed(new_speed):
	speed = new_speed

func _physics_process(delta):
	position.x += speed * delta

func _on_body_entered(_body):
	bird_enterned.emit()

func _on_point_scored(_body):
	point_scored.emit()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
