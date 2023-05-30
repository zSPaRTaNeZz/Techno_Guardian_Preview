extends Popup

onready var fullscreen_button = get_node("TabContainer/General/MarginContainer/GridContainer/Fullscreen button")
onready var window_selector = get_node("TabContainer/General/MarginContainer/GridContainer/SizeSelector")
onready var volume_slider = get_node("TabContainer/General/MarginContainer/GridContainer/MasterVolumeSlider")

var fullscreen
var screen_indx
var master_volume

func _ready():
	set_def_param()

func set_def_param():
	fullscreen = Save.game_data["fullscreen"]
	fullscreen_button.pressed = fullscreen
	
	screen_indx = Save.game_data["screen_indx"]
	window_selector.selected = screen_indx
	
	master_volume = Save.game_data["master_volume"]
	volume_slider.value = master_volume

func _on_Fullscreen_button_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	fullscreen = button_pressed
	window_selector.disabled = button_pressed


func _on_OptionButton_item_selected(index):
	screen_indx = index
	var values = window_selector.text.split_floats("x")
	OS.window_size = Vector2(values[0],values[1])

# -50  24
func _on_MasterVolumeSlider_value_changed(value):
	master_volume = volume_slider.value
	var new_value = -40 + 0.74 * volume_slider.value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), new_value)

func _on_Save_pressed():
	Save.game_data["fullscreen"] = fullscreen
	Save.game_data["screen_indx"] = screen_indx
	Save.game_data["master_volume"] = master_volume
	Save.save_data()

func _on_Return_pressed():
	hide()
	pass # Replace with function body.
