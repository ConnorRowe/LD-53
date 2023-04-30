extends Control


func _on_button_pressed():
	$Icon/Wobbler.wobble(2)


func _on_button_mouse_entered():
	$Button/Wobbler.wobble(1)
