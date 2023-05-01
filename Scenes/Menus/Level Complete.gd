extends Control

@onready var fake_jeej = $"Fake jeej"

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Score Label".text = "Score: %s" % GameData.score
	GameData.max_level = maxi(GameData.current_level + 1, GameData.max_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fake_jeej.rotation += delta * PI



func _on_back_pressed():
	if GameData.current_level >= 5:
		Transition.transition_to_scene("res://Scenes/Menus/Complete Screen.tscn")
	else:
		Transition.transition_to_scene("res://Scenes/Menus/Level Selection.tscn")
