@tool
extends Node2D

@export var num_postboxes: int
@export var delivery_desc: String = ""
@export var envelope_types: PackedInt32Array
@onready var player: Player = $Player
var last_checkpoint: Checkpoint = null
var player_start_pos: Vector2;

func _ready():
	player_start_pos = player.position
	num_postboxes = $"Post Boxes".get_child_count()


func _on_player_reached_checkpoint(checkpoint):
	last_checkpoint = checkpoint


func _on_player_reset_to_last_checkpoint():
	player.direction = 1
	player.velocity = Vector2.ZERO
	if is_instance_valid(last_checkpoint):
		player.global_position = last_checkpoint.global_position
	else:
		player.position = player_start_pos

