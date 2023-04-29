extends VBoxContainer

@onready var master_h_slider = $"Master HSlider"
@onready var music_h_slider = $"Music HSlider"
@onready var sfx_h_slider = $"SFX HSlider"
@onready var fullscreen_check_button = $"Fullscreen CheckButton"
var master_bus
var music_bus
var sfx_bus

func _ready():
	master_bus = AudioServer.get_bus_index("Master")
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("SFX")
	
	master_h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	music_h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	sfx_h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))

func _on_master_h_slider_value_changed(value):
	vol_value_changed(value, master_bus)


func _on_music_h_slider_value_changed(value):
	vol_value_changed(value, music_bus)


func _on_sfx_h_slider_value_changed(value):
	vol_value_changed(value, sfx_bus)


func _on_fullscreen_check_button_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func vol_value_changed(vol: float, bus_index: int):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(vol))
	Sounds.pop()
