extends CharacterBody2D

class_name Bird

signal game_started

@export var gravity = 900.0
@export var jump_force = -300.0
@export var rotation_speed = 2

@onready var animation_player = $AnimationPlayer
@onready var deathsound: AudioStreamPlayer = $deathsound


var max_speed = 400
var is_started = false
var should_process_input = true

func _ready():
	velocity = Vector2.ZERO
	animation_player.play("idle")
	
func _physics_process(delta):
	if Input.is_action_just_pressed("Jump") && should_process_input:
		if !is_started:
			game_started.emit()
			animation_player.play("flap_wings")
			is_started = true
		Jump()
	
	if !is_started:
		return
	velocity.y += gravity * delta
	
	velocity.y = min(velocity.y, max_speed)
	
	move_and_collide(velocity * delta)
	
	rotate_bird()
	
	if velocity.y > max_speed:
		velocity.y = max_speed
		
	

func Jump():
	$jumpeye.play()
	velocity.y = jump_force
	rotation = deg_to_rad(-30)

func rotate_bird():
	#Rotate downwards when faling
	if velocity.y > 0 && deg_to_rad(rotation) < 90:
		rotation += rotation_speed * deg_to_rad(1)
	#Rotate upward when rising
	elif velocity.y < 0 && rad_to_deg(rotation) > -30:
		rotation -= rotation_speed * deg_to_rad(1)

func kill():
	$deathsound.play()
	should_process_input = false

func stop():
	animation_player.stop()
	gravity = 0
	velocity = Vector2.ZERO
	should_process_input = false


func _on_area_2d_area_entered(_area):
	pass # Replace with function body.

var hasPowerUp = false
