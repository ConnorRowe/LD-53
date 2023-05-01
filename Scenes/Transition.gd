extends CanvasLayer

@onready var sprite_2d = $Sprite2D

func transition_to_scene(scene: String):
	visible = true
	var tween = create_tween()
	tween.set_parallel(false)
	
	var fade_in_tweener = tween.tween_property(sprite_2d.material, "shader_parameter/progress", 1.0, 1.0)
	fade_in_tweener.from(0.0)
	fade_in_tweener.connect("finished", Callable(self, "change_scene").bind(scene))
	
	var fade_out_tweener = tween.tween_property(sprite_2d.material, "shader_parameter/progress", 0.0, 1.0)
	fade_out_tweener.from(1.0)
	fade_out_tweener.connect("finished", Callable(self, "pause_tree").bind(false))
	fade_out_tweener.connect("finished", Callable(self, "set").bind("visible", false))
	
	pause_tree(true)


func change_scene(scene: String):
	get_tree().change_scene_to_file(scene)

func pause_tree(paused: bool):
	get_tree().paused = paused

