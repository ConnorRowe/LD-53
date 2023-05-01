extends Control

@onready var fake_jeej = $"Fake jeej"

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Score Label".text = "Score: %s" % GameData.score
	GameData.max_level = GameData.current_level + 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fake_jeej.rotation += delta * PI


func _on_back_pressed():
	Transition.transition_to_scene("res://Scenes/Menus/Level Selection.tscn")
