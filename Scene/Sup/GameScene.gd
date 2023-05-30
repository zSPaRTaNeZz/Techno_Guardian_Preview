extends Node2D

signal game_finished(result)

var map = "map_1"
var map_node

var build_mode = false
var build_valid = false
var build_tile
var build_location
var build_type

var current_wave = 0
var enemies_remain = 0

var gold = 100
var influence = 100       # Minetech
var tower_price = 0

var card_draw = 2

func _ready():
	get_node("UI/HUD/CardManager").Generate_card(card_draw)
	map_node = get_node("Map1")
	get_node("UI").update_cash(gold)
	get_node("UI").update_influence(influence)
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])

func _process(delta):
	if build_mode :
		update_tower_preview()

func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()

##
## Wave functions
##

func start_next_wave():
#	update tower parametrs
	var node = get_node("Map1/Buildings")
	for i in range(node.get_child_count()):
		node.get_child(i).update_param()
	
	var wave_data = retrive_wave_data()
	yield(get_tree().create_timer(0.2),"timeout") ## padding between waves
	map_node.spawn_enemies(wave_data)
#	spawn_enemies(wave_data)

func retrive_wave_data():
#	var wave_data = Global.wave[map][current_wave]
	var wave_data = Global.wave[map][0]
	current_wave +=1
	get_node("UI/HUD/InfoBar/H/Wave").text = str(current_wave)
	for i in wave_data:
		enemies_remain += i[2] * i[3]
	get_node("UI/HUD/InfoBar/H/Enemy").text = str(enemies_remain)
	return wave_data

#func spawn_enemies(wave_data):
#	for i in wave_data:
#		for j in i[1]:
#			var new_enemy = load("res://Scene/Enemy/" + i[0] + ".tscn").instance()
#			new_enemy.position = Vector2(780, 0)
#			map_node.get_node("Enemies").add_child(new_enemy, true)
#			yield(get_tree().create_timer(0.5),"timeout")
#		yield(get_tree().create_timer(2.0),"timeout")


func on_enemy_destroy():
	enemies_remain -= 1
	get_node("UI/HUD/InfoBar/H/Enemy").text = str(enemies_remain)
	if enemies_remain == 0:
		income()
		get_node("UI/HUD/CardManager").Generate_card(card_draw)
		get_node("UI").show_hud()

func income():
	add_resources(0, 20)

##
## Card function
##
func add_resources(n_gold,n_influence):
	gold += n_gold
	influence += n_influence
	get_node("UI").update_cash(gold)
	get_node("UI").update_influence(influence)

##
## Building functions
##
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	build_type = tower_type
	build_mode = true
#	GameData.build_state = true
	# set tower preview and retrive tower price
	tower_price = get_node("UI").set_tower_preview(build_type, get_global_mouse_position())
#	get_node("UI/HUD/BuildBar").hide()

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map_node.get_node("BuildingExclusion").world_to_map(mouse_position)
	var tile_position = map_node.get_node("BuildingExclusion").map_to_world(current_tile)
	
	if map_node.get_node("BuildingExclusion").get_cellv(current_tile) == -1:
		get_node("UI").update_tower_preview(tile_position, "ad54ff3c")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		get_node("UI").update_tower_preview(tile_position, "adff4545")
		build_valid = false

func cancel_build_mode():
	build_mode = false
#	GameData.build_state = false
	build_valid = false
	get_node("UI/TowerPreview").free()
	Global.TowerPreview = null

func verify_and_build():
	if build_valid:
		if gold < tower_price:
			# error sound
			pass
		else:
			var new_tower = load("res://Scene/Buildings/" + build_type + ".tscn").instance()
			new_tower.position = build_location
			new_tower.build = true
#			new_tower.type = build_type
#			new_tower.category = GameData.tower_data[build_type]["category"] 
			map_node.get_node("Buildings").add_child(new_tower, true)
			map_node.get_node("BuildingExclusion").set_cellv(build_tile, 0)
			
			gold -= tower_price
			get_node("UI").update_cash(gold)
	else:
		# error sound
		pass

func Game_Over():
	emit_signal("game_finished", false)
