extends Node

@onready var pop_player = $"Pop Player"
@onready var reverse_player = $"Reverse Player"
@onready var delivery_player = $"Delivery Player"
@onready var score_player = $"Score Player"
@onready var music_player = $"Music Player"

var main_theme: AudioStreamOggVorbis = preload("res://Sounds/main_theme.ogg")
var menu_theme: AudioStreamOggVorbis = preload("res://Sounds/menu_theme.ogg")

func pop():
	if !pop_player.playing:
		pop_player.play()

func reverse():
	reverse_player.play()

func delivery():
	delivery_player.play()

func score():
	score_player.play()

func fade_music(track: AudioStreamOggVorbis):
	var tween = create_tween()	
	tween.tween_property(music_player, "volume_db", -50, 1)
	tween.connect("finished", Callable(self, "switch_music_track").bind(track))

func switch_music_track(track: AudioStreamOggVorbis):
	music_player.stream = track
	music_player.volume_db = 0
	music_player.play(0)
