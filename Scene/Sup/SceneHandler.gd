extends Node

func _ready():
	randomize()
	Global.total_cards = Global.card.size()
	load_main_menu()

func load_main_menu():
	get_node("MainMenu/M/VB/NewGame").connect("pressed",self,"on_new_game_pressed")
	get_node("MainMenu/M/VB/Quit").connect("pressed",self,"on_quit_pressed")
	get_node("MainMenu/M/VB/Settings").connect("pressed",self,"on_settings_pressed")

func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scene/Sup/GameScene.tscn").instance()
	game_scene.connect("game_finished", self, "unload_game") # GAME OVER
	add_child(game_scene)

func on_settings_pressed():
	get_node("CanvasLayer/Settings_menu").popup()

func on_quit_pressed():
	get_tree().quit()

func unload_game(result):
	get_node("GameScene").queue_free()
	var main_menu = load ("res://Scene/Sup/MainMenu.tscn").instance()
	add_child(main_menu)
	load_main_menu()
