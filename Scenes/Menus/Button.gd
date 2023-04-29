extends Button

func _ready():
	pivot_offset = size / 2

func _on_mouse_entered():
	Sounds.pop()
