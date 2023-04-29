extends Control


func _on_button_pressed():
	$Icon/Wobbler.shake(2)


func _on_button_mouse_entered():
	$Button/Wobbler.shake(1)
