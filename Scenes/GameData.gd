extends Node

var score: int = 0
var current_level = 0

var max_level: int :
	get:
		return config_file.get_value("jiji", "max_level", 0)
	set(value):
		config_file.set_value("jiji", "max_level", value)
		config_file.save(save_path)

const save_path = "user://save.ini"
var config_file: ConfigFile = ConfigFile.new()

func _ready():
	var error = config_file.load(save_path)
	if error == Error.OK:
		print("Loaded save data")
	else:
		print("Failed to load save data: re-creating", error)
		
		config_file.set_value("jiji", "max_level", 0)
		config_file.save(save_path)

func _input(event):
	if event.is_action_released("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
