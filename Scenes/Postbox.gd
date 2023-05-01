class_name Postbox extends Node2D

var is_empty: bool = true

signal made_delivery(accuracy)

@onready var bg: Sprite2D = $BG
@onready var postbox: Sprite2D = $Postbox
@onready var arrow: AnimatedSprite2D = $Arrow
@onready var area_2d = $Area2D
@onready var bg_mat: ShaderMaterial = bg.material
@onready var wobbler = $Postbox/Wobbler
var accuracy: int = 0

func fill():
	is_empty = false
	bg.visible = false
	postbox.frame = 1
	arrow.visible = false
	area_2d.monitorable = false
	area_2d.queue_free()
	get_node("Confetti%s" % (accuracy + 1)).emitting = true
	made_delivery.emit(accuracy)
	wobbler.wobble(float(accuracy) / 2)
	Sounds.delivery()

func update_distance(player_global_pos: Vector2):
	var scaled_distance = clampf(to_local(player_global_pos).length() / 39.0, 0, 1)
	bg_mat.set_shader_parameter("progress", scaled_distance)
	accuracy = floori((1.0 - scaled_distance) * 3)
	
