extends Node

class_name PipeSpawner

signal bird_crashed
signal point_scored

const POWER_UP = preload("res://scenes/power_up.tscn")

var pipe_pair_scene = preload("res://scenes/pipe_pair.tscn")

@export var pipe_speed = -150
@export var bird: Bird

@onready var spawn_timer = $SpawnTimer
@onready var pointsound = $pointsound


func _ready():
	spawn_timer.start()

func start_spawning_pipes():
	spawn_timer.timeout.connect(spawn_pipe)

func spawn_pipe():
	var pipe = pipe_pair_scene.instantiate() as PipePair
	var pipe2 = pipe.get_node("Scored")
	
	var viewport_rect = get_viewport().get_camera_2d().get_viewport_rect()
	pipe.position.x = viewport_rect.end.x
	
	var half_height = viewport_rect.size.y/2
	pipe.position.y = randf_range(viewport_rect.size.y * 0.15 - half_height, viewport_rect.size.y * 0.65 - half_height)
	pipe.bird_enterned.connect(on_bird_entered.bind(pipe))
	pipe.point_scored.connect(on_point_scored)
	pipe.set_speed(pipe_speed)
	add_child(pipe)
	if randf() <= 0.1:  # 10% szansa
		var newPowerUp = POWER_UP.instantiate()
		newPowerUp.position = Vector2(viewport_rect.end.x, pipe.position.y)
		add_child(newPowerUp)
	
func on_bird_entered(pipe):
	if bird.hasPowerUp:
		pipe.get_node("TopPipe").queue_free()
		pipe.get_node("BottomPipe").queue_free()
		bird.hasPowerUp = false
	else:
		bird_crashed.emit()
		stop()

func stop():
	spawn_timer.stop()
	for pipe in get_children().filter(func (child): return child is PipePair):
		(pipe as PipePair).speed = 0
	
	var PowerUps = get_tree().get_nodes_in_group("PowerUp")
	for ElementPower in PowerUps:
		ElementPower.queue_free()
	
func on_point_scored():
	point_scored.emit()
	pointsound.play()
