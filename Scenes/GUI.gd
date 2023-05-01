class_name GUI extends Control


@onready var envelope_h_box: HBoxContainer = $"Envelope HBox"
const envelope_textures: Array = [preload("res://Textures/envelope_1.png"), preload("res://Textures/envelope_2.png"), preload("res://Textures/envelope_3.png")]
@onready var hit_text = $"Hit Text"
@onready var hit_text_2 = $"Hit Text/Hit Text2"
const hit_texts: PackedStringArray = ["only just...", "not bad", "PERFECT DELIVERY!"]
var hit_colours: PackedColorArray = [Color("#5672e1"), Color("#93c7e3"), Color("#eeb8b4")]
@onready var hittext_wobbler = $"Hit Text/Wobbler"
@onready var score_text = $"Score Text"
@onready var pause_screen = $"Pause Screen"


func _input(event):
	if event.is_action_released("pause"):
		toggle_pause()

func add_envelopes(array: PackedInt32Array):
	for i in array:
		var tex = TextureRect.new()
		tex.stretch_mode = TextureRect.STRETCH_KEEP
		tex.texture = envelope_textures[i]
		envelope_h_box.add_child(tex)

func show_hit_text(accuracy: int):
	hit_text.text = hit_texts[accuracy]
	hit_text_2.text = hit_texts[accuracy]
	hit_text.set("theme_override_colors/font_color", hit_colours[accuracy])
	hit_text.visible = true
	hittext_wobbler.wobble(accuracy + 1)
	get_tree().create_timer(5).connect("timeout", Callable(hit_text, "set").bindv(["visible", false]))

func deliver_last_envelope(postbox_gpos: Vector2, player_gpos: Vector2):
	var last: TextureRect = envelope_h_box.get_child(envelope_h_box.get_child_count() - 1)
	var new_sprite = Sprite2D.new()
	new_sprite.texture = last.texture
	get_tree().current_scene.add_child(new_sprite)
	
	var tween = create_tween()
	var move_tweener = tween.tween_property(new_sprite, "global_position", postbox_gpos, 2.0)
	move_tweener.set_ease(Tween.EASE_IN_OUT)
	move_tweener.from(player_gpos + Vector2(-160, -90) + last.global_position)
	move_tweener.set_trans(Tween.TRANS_CUBIC)
	tween.connect("finished", Callable(new_sprite, "queue_free"))
	
	envelope_h_box.remove_child(last)

func update_score(score: int):
	score_text.text = "Score: %s" % score

func toggle_pause():
	pause_screen.visible = !pause_screen.visible	
	get_tree().paused = pause_screen.visible


func _on_return_pressed():
	toggle_pause()


func _on_quit_pressed():
	get_tree().paused = false
	Transition.transition_to_scene("res://Scenes/Menus/Level Selection.tscn")
	Sounds.fade_music(Sounds.menu_theme)
