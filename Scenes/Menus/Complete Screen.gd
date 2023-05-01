extends Control


func _ready():
	Sounds.delivery()

func _on_label_mouse_entered():
	$Label/Wobbler.wobble(1)


func _on_return_pressed():
	Transition.transition_to_scene("res://Scenes/Menus/Main Menu.tscn")
