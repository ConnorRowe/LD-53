extends Node

@onready var pop_player = $"Pop Player"

func pop():
	if !pop_player.playing:
		pop_player.play()
