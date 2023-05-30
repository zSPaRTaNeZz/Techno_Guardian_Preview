extends Control

func _on_Resume_pressed():
	self.hide()

func _on_Settings_pressed():
	get_node("../../../../CanvasLayer/Settings_menu").popup()

func _on_Quit_pressed():
	get_node("../../..").Game_Over()
