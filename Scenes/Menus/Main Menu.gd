extends Control

func _on_godot_button_pressed():
	$Icon/Wobbler.wobble(3)


func _on_settings_button_pressed():
	Transition.transition_to_scene("res://Scenes/Menus/Settings Menu.tscn")


func _on_enter_button_pressed():
	Transition.transition_to_scene("res://Scenes/Menus/Level Selection.tscn")


func _on_godot_button_mouse_entered():
	$Icon/Wobbler.wobble(1)
