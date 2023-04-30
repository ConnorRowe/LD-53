class_name Postbox extends Node2D

var is_empty: bool = true

@onready var bg: Sprite2D = $BG
@onready var postbox: Sprite2D = $Postbox
@onready var arrow: AnimatedSprite2D = $Arrow
@onready var area_2d = $Area2D

func fill():
	is_empty = false
	bg.visible = false
	postbox.frame = 1
	arrow.visible = false
	area_2d.queue_free()
