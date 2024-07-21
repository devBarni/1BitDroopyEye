extends CanvasLayer

func _ready():
	pass # Replace with function body.

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_exit_pressed():
	get_tree().quit()
	
func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
