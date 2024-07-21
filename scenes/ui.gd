extends CanvasLayer
class_name UI

const SAVE_FILE = "user://highscore.save"

@onready var points_label = $MarginContainer/PointsLabel
@onready var game_over_box = $MarginContainer/GameOverBox
@onready var high_score_label = $MarginContainer/HighScoreLabel

var highscore = 0

func _ready():
	points_label.text = "0"
	load_highscore()
	update_highscore_display()

func save_highscore():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_var(highscore)
		file.close()
	else:
		print("Błąd zapisu.")

func load_highscore():
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		if file:
			highscore = file.get_var()
			file.close()
		else:
			print("Błąd odczytu")
	else:
		highscore = 0

func update_highscore(points):
	if points > highscore:
		highscore = points
		save_highscore()
	update_highscore_display()

func update_highscore_display():
	$MarginContainer/HighScoreLabel.text = "Highscore: %d" % highscore

func get_highscore():
	return highscore

func update_points(points: int):
	points_label.text = str(points)

func on_game_over():
	game_over_box.visible = true
	high_score_label.visible = true
	update_highscore_display()

func _on_button_pressed():
	get_tree().reload_current_scene()
