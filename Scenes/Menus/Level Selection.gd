extends Node2D

@onready var speech_label = $"PanelContainer/Speech Label"

var level_speeches: PackedStringArray = [	"Mornin Jeej, just a few standard letters to deliver. Should be easy enough.",
											"Alright Jiji? A few more letters for you again today. Looks like one of 'em's a love letter. *sigh*",
											"placeholder",
											"placeholder",
											"placeholder",
											"placeholder"]

const new_char_time: float = 0.07
var char_timer: float = 0.0
@onready var greg = $Greg
var selected_level: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_speech_text("Mornin' Jeej pal")


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
