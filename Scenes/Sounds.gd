extends Node

@onready var pop_player = $"Pop Player"
@onready var reverse_player = $"Reverse Player"

func pop():
	if !pop_player.playing:
		pop_player.play()

func reverse():
	reverse_player.play()
