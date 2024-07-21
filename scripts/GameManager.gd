extends Node

@onready var bird = $"../Bird" as Bird
@onready var pipe_spawner = $"../PipeSpawner" as PipeSpawner
@onready var ground = $"../Ground" as Ground
@onready var fade = $"../Fade" as Fade
@onready var ui = $"../UI" as UI
@onready var parallax_background = $"../ParallaxBackground"

var points = 0
var highscore = 0
const SAVE_FILE = "user://highscore.save"

func _ready():
	bird.game_started.connect(on_game_started)
	ground.bird_crashed.connect(end_game)
	pipe_spawner.bird_crashed.connect(end_game)
	pipe_spawner.point_scored.connect(on_point_scored)
	load_highscore()
	ui.update_highscore(highscore)

func on_game_started():
	pipe_spawner.start_spawning_pipes()

func end_game():
	if fade != null:
		fade.play()
	ground.stop()
	bird.kill()
	pipe_spawner.stop()
	update_highscore()
	ui.on_game_over()

func on_point_scored():
	points += 1
	ui.update_points(points)

func update_highscore():
	print("Aktualna liczba punktów: ", points) 
	print("Aktualny highscore: ", highscore)  
	if points > highscore:
		highscore = points
		save_highscore()
		print("Nowy highscore: ", highscore) 
	ui.update_highscore(highscore)

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
			print("Błąd odczytu.")
	else:
		highscore = 0
