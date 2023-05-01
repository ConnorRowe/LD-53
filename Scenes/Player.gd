class_name Player extends CharacterBody2D

signal reset_to_last_checkpoint
signal reached_checkpoint(checkpoint)
signal picked_up_score

const SPEED: float = 50.0
const JUMP_VELOCITY: float = -280.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var has_jumped: bool = false
@onready var wobbler = $Jiji/Wobbler
@onready var skamtebord = $Skamtebord
@onready var rail_area_2d = $"Rail Area2D"
@onready var jiji = $Jiji
@onready var dust_particles = $"Dust Particles"
@onready var grind_bus_timer = $"Grind Bus Timer"
@onready var grind_player = $"Grind Player"
@onready var grind_ollie_player = $"Grind Ollie Player"
@onready var drop_jump_timer = $"Drop Jump Timer"
@onready var tail = $Tail

@export var frozen: bool = false

var is_on_rail: bool = false
var current_rail: Rail
var rail_percent: float = 0.0
var near_postbox: bool = false
var last_postbox: Postbox = null
var grind_phaser: AudioEffectPhaser = AudioServer.get_bus_effect(AudioServer.get_bus_index("Grind"), 0)
var can_drop_jump:bool = false

var direction: int = 1 : set = set_direction

func _ready():
	grind_player.play()
	grind_player.set_deferred("stream_paused", true)


func _input(event):
	if frozen:
		return
	
	if near_postbox and not is_on_rail and not is_on_floor() and event.is_action_pressed("jump"):
		last_postbox.fill()
		near_postbox = false

func _process(_delta):
	if near_postbox:
		last_postbox.update_distance(global_position)
	
	if not is_on_rail and not grind_player.stream_paused:
		grind_player.set_deferred("stream_paused", true)

func _physics_process(delta):
	if frozen:
		return
	
	if is_on_rail:
		var rail_movement = (SPEED * delta * 0.05) / current_rail.get_point_count()
		if direction < 0:
			rail_movement *= -1
		
		rail_percent += rail_movement
		
		if (direction > 0 and rail_percent >= 1.0) or (direction < 0 and rail_percent <= 0.0):
			detach_from_rail()
		elif Input.is_action_just_pressed("jump"):
			detach_from_rail()
			jump()
			grind_ollie_player.play()
		else:
			var p = (current_rail.get_point_count() - 1) * rail_percent
			var floored = floori(p)
			var remainder = p - floored
			var point_a = current_rail.get_point_position(floored)
			var point_b = current_rail.get_point_position(floored + 1)
			var lerped = lerp(point_a, point_b, remainder)
			var angle = point_a.angle_to_point(point_b)
			rotation = angle
			
			global_position = current_rail.to_global(lerped)
	
	if is_on_rail:
		return
	
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	# When landed
	elif has_jumped:
		wobbler.wobble(2)
		has_jumped = false

	# Handle Jump
	if Input.is_action_just_pressed("jump") and (is_on_floor() or can_drop_jump):
		jump()

	# Horizontal movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if rail_area_2d.monitoring and velocity.y < 0:
		rail_area_2d.monitoring = false
	elif not rail_area_2d.monitoring and velocity.y > 0:
		rail_area_2d.monitoring = true
	
	if is_on_wall() or position.y > 400:
		reset_to_last_checkpoint.emit()

func jump():
	velocity.y = JUMP_VELOCITY
	has_jumped = true
	can_drop_jump = false

func attach_to_rail(rail: Rail):
	if frozen:
		return
		
	if rail.is_rail_below_position(global_position):
		print("attached to rail")
		current_rail = rail
		is_on_rail = true
		rail_percent = rail.find_percent_at_position(global_position)
		print("rail_percent:", rail_percent)
		skamtebord.frame = 1
		wobbler.wobble(1)
		dust_particles.emitting = true 
		grind_player.stream_paused = false
		grind_ollie_player.play()

func detach_from_rail():
	is_on_rail = false
	skamtebord.frame = 0
	rotation = 0.0
	velocity.y = 0
	dust_particles.emitting = false
	grind_player.stream_paused = true
	can_drop_jump = true
	drop_jump_timer.start()

# Reverse direction
func _on_board_area_2d_area_entered(area):
	if frozen:
		return
	
	var parent = area.get_parent()
	if parent is ReversePad:
		if parent.rotation == 0.0:
			direction = -1
		else:
			direction = 1

		parent.wobble()
		Sounds.reverse()


func _on_rail_area_2d_body_entered(body):
	if frozen:
		return
		
	var rail = body.get_parent()
	if rail is Rail:
		attach_to_rail(rail)

func reset():
	detach_from_rail()
	reset_to_last_checkpoint.emit()


func _on_pickup_area_2d_area_entered(area):
	if frozen:
		return
		
	var parent = area.get_parent()
	if parent is Checkpoint:
		reached_checkpoint.emit(parent)
		parent.activate()
	elif parent is Postbox and parent.is_empty:
		near_postbox = true
		last_postbox = parent
	elif parent.has_meta("score"):
		parent.queue_free()
		picked_up_score.emit()


func _on_pickup_area_2d_area_exited(area):
	var parent = area.get_parent()
	if parent is Postbox:
		near_postbox = false


func set_direction(value):
	direction = value
	jiji.flip_h = direction < 0
	dust_particles.scale.x = direction

func _on_grind_bus_timer_timeout():
	grind_bus_timer.wait_time = randf_range(1, 5)
	grind_phaser.rate_hz = randf_range(0.08, 0.2)


func _on_drop_jump_timer_timeout():
	can_drop_jump = false
