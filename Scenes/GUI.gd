extends Control


@onready var envelope_h_box: HBoxContainer = $"Envelope HBox"
const envelope_textures: Array = [preload("res://Textures/envelope_1.png"), preload("res://Textures/envelope_2.png"), preload("res://Textures/envelope_3.png")]

func add_envelopes(array: PackedInt32Array):
	for i in array:
		var tex = TextureRect.new()
		tex.stretch_mode = TextureRect.STRETCH_KEEP
		tex.texture = envelope_textures[i]
		envelope_h_box.add_child(tex)
