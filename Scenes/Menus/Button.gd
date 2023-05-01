extends Button

@onready var wobbler = $Wobbler

func _ready():
	pivot_offset = size / 2

func _on_mouse_entered():
	if disabled:
		return
	Sounds.pop()
	wobbler.wobble(1)
