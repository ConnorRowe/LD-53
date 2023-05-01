extends Node2D

@onready var shape_cast_2d = $ShapeCast2D

func _physics_process(delta):
	if shape_cast_2d.get_collision_count() > 0:
		var parent = shape_cast_2d.get_collider(0).get_parent()
		if parent is Player:
			parent.reset()
		print("reset")
