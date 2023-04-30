class_name Checkpoint extends Node2D


@onready var bg = $BG
@onready var fg = $FG
var activated_tex = preload("res://Textures/checkpoint_activated.png")

func activate():
	bg.visible = false
	fg.texture = activated_tex
