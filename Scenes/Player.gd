class_name Player extends CharacterBody2D

signal reset_to_last_checkpoint
signal reached_checkpoint(checkpoint)

const SPEED: float = 50.0
const JUMP_VELOCITY: float = -250.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var has_jumped: bool = false
@onready var wobbler = $Jiji/Wobbler
@onready var skamtebord = $Skamtebord
@onready var rail_area_2d = $"Rail Area2D"
@onready var jiji = $Jiji
@onready var dust_particles = $"Dust Particles"

var is_on_rail: bool = false
var current_rail: Rail
var rail_percent: float = 0.0

var direction: int = 1 : set = set_direction

func _physics_process(delta):
	
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
	if Input.is_action_just_pressed("jump") and is_on_floor():
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

func attach_to_rail(rail: Rail):
	if rail.is_rail_below_position(global_position):
		print("attached to rail")
		current_rail = rail
		is_on_rail = true
		rail_percent = rail.find_percent_at_position(global_position)
		print("rail_percent:", rail_percent)
		skamtebord.frame = 1
		wobbler.wobble(1)
		dust_particles.emitting = true

func detach_from_rail():
	is_on_rail = false
	skamtebord.frame = 0
	rotation = 0.0
	velocity.y = 0
	dust_particles.emitting = false
	

# Reverse direction
func _on_board_area_2d_area_entered(area):
	var parent = area.get_parent()
	if parent is ReversePad:
		if parent.rotation == 0.0:
			direction = -1
		else:
			direction = 1

		parent.wobble()


func _on_rail_area_2d_body_entered(body):
	var rail = body.get_parent()
	if rail is Rail:
		attach_to_rail(rail)

func reset():
	reset_to_last_checkpoint.emit()


func _on_pickup_area_2d_area_entered(area):
	var parent = area.get_parent()
	if parent is Checkpoint:
		reached_checkpoint.emit(parent)
		parent.activate()
	
func set_direction(value):
	direction = value
	jiji.flip_h = direction < 0
	dust_particles.scale.x = direction
