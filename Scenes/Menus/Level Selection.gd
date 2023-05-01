extends Node2D

@onready var speech_label = $"PanelContainer/MarginContainer/Speech Label"

var level_speeches: PackedStringArray = [	"Mornin Jeej, just one standard letter to deliver. Should be easy enough.",
											"Alright Jiji? A few more letters for you again today. Looks like one of 'em's a love letter. *sigh*",
											"Got a letter and a parcel now, but seems like the recipient's a bit of a nut - set up a bunch of spike traps. Be careful.",
											"A few things to deliver this time, would be easy, 'cept the desination is the top of Tall Towers...",
											"Just one parcel this time thankfully, only problem is the guy lives inside the belly of some great beast. Good luck.",
											"This is your last delivery Jiji, and it'll be a tough one. You're the bravest cat I know. You can do it."]

const new_char_time: float = 0.05
var char_timer: float = 0.0
@onready var greg = $Greg
var selected_level: int = -1
@onready var arrow = $Arrow


func _ready():
	set_speech_text("Mornin' Jiji pal.")
	var max_level = GameData.max_level
	for i in range(1, 7):
		get_node("Level%s" % i).disabled = max_level < i - 1


func _process(delta):
	if speech_label.visible_ratio < 1.0:
		char_timer += delta
		
		var chars = floori(char_timer / new_char_time)
		char_timer -= chars * new_char_time
		
		speech_label.visible_characters += chars
		
		Sounds.pop()
		
		if speech_label.visible_ratio >= 1.0:
			greg.stop()
			greg.frame = 0

func set_speech_text(text: String):
	speech_label.visible_characters = 0
	speech_label.text = text
	greg.play("default")

func select_level(level):
	selected_level = level
	set_speech_text(level_speeches[level])
	$Start.disabled = false
	arrow.position = get_node("Level%s" % (level + 1)).position
	
	
func _on_level_1_pressed():
	select_level(0)

func _on_level_2_pressed():
	select_level(1)

func _on_level_3_pressed():
	select_level(2)

func _on_level_4_pressed():
	select_level(3)

func _on_level_5_pressed():
	select_level(4)

func _on_level_6_pressed():
	select_level(5)

func _on_start_pressed():
	GameData.current_level = selected_level
	Transition.transition_to_scene("res://Scenes/Levels/Level%s.tscn" % (selected_level + 1))
	Sounds.fade_music(Sounds.main_theme)

func _on_back_pressed():
	Transition.transition_to_scene("res://Scenes/Menus/Main Menu.tscn")
