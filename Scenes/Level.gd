@tool
extends Node2D


@export var num_postboxes: int
@export var delivery_desc: String = ""
@export var envelope_types: PackedInt32Array
@onready var player: Player = $Player
var last_checkpoint: Checkpoint = null
var player_start_pos: Vector2;
@onready var gui: GUI = $"UI Layer/GUI"
var score = 0
var deliveries_made = 0

func _ready():
	player_start_pos = player.position
	num_postboxes = $"Post Boxes".get_child_count()
	if not Engine.is_editor_hint():
		for postbox in $"Post Boxes".get_children():
			postbox.made_delivery.connect(on_delivery_made)
		gui.add_envelopes(envelope_types)
		gui.update_score(score)

func on_delivery_made(accuracy):
	gui.show_hit_text(accuracy)
	gui.deliver_last_envelope(player.last_postbox.global_position, player.global_position)
	score += 100 * (accuracy + 1)
	gui.update_score(score)
	deliveries_made += 1
	
	if deliveries_made >= num_postboxes:
		GameData.score = score
		
		var tmr = get_tree().create_timer(1)
		await tmr.timeout
		Transition.transition_to_scene("res://Scenes/Menus/Level Complete.tscn")

func _on_player_reached_checkpoint(checkpoint):
	last_checkpoint = checkpoint

func _on_player_reset_to_last_checkpoint():
	player.direction = 1
	player.velocity = Vector2.ZERO
	if is_instance_valid(last_checkpoint):
		player.global_position = last_checkpoint.global_position
	else:
		player.position = player_start_pos

