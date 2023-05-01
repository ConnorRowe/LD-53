extends Node2D

@onready var shape_cast_2d = $ShapeCast2D

var can_hit: bool = true

func _physics_process(_delta):
	if not can_hit:
		return
		
	if shape_cast_2d.get_collision_count() > 0:
		var parent = shape_cast_2d.get_collider(0).get_parent()
		if parent is Player:
			parent.reset()
			can_hit = false
			get_tree().create_timer(.5).timeout.connect(Callable(self, "set").bind("can_hit", true))
		
