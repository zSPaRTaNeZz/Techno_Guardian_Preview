extends CanvasLayer

var camera

var n_button = preload("res://Assets/HUD/G.png")
var p_button = preload("res://Assets/HUD/blue_button03.png")

func _ready():
	camera = get_parent().get_node("Camera2D")

##
## Tower preview
##
func set_tower_preview(tower_type, mouse_position):
	# hide cards
	get_node("HUD/CardManager").visible = false
	
	var drag_tower = load("res://Scene/Buildings/" + tower_type + ".tscn").instance()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff3c") # green color
	
	var range_texture = Sprite.new()
	range_texture.position = Vector2(16, 16)
	var scaling = drag_tower.attack_range / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://Assets/HUD/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ad54ff3c") # green color
	
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.rect_position = mouse_position
	control.rect_position = to_local(mouse_position)
	control.rect_scale = Vector2(1.0, 1.0) / camera.zoom
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0)
	Global.TowerPreview = get_node("TowerPreview")
	return drag_tower.price

func update_tower_preview(new_position, color):
	get_node("TowerPreview").rect_position = new_position
	get_node("TowerPreview").rect_position = to_local(new_position)
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/Sprite").modulate = Color(color)

##
## Update HUD info
##
func update_cash(cash):
	get_node("HUD/InfoBar/H/Cash").text = str(cash)

func update_influence(influence):
	get_node("HUD/InfoBar/H/Influence").text = str(influence)

##
## Change global pos to local
##
func to_local(glob_pos):
	return (glob_pos - get_parent().get_node("Camera2D").position + Vector2(1600,960) / 2 * camera.zoom) / camera.zoom

##
## HUD buttons functions
##
func hide_hud():
	get_node("HUD/GameContorls/NextWave").visible = false
	get_node("HUD/Build").visible = false
	get_node("HUD/BuildMenu").visible = false

func show_hud():
	get_node("HUD/GameContorls/NextWave").visible = true
	get_node("HUD/Build").visible = true


func _on_Build_pressed():
	get_node("HUD/BuildMenu").visible = !get_node("HUD/BuildMenu").visible


func _on_NextWave_pressed():
	get_node("HUD/CardManager").cards_destroy()
	get_parent().start_next_wave()
	hide_hud()


func _on_SpeedDown_pressed():
	if Engine.get_time_scale() < 1:
		_on_Play_pressed()
	else:
		Engine.set_time_scale(0.2)
		get_node("HUD/GameContorls/Play").texture_normal = n_button
		get_node("HUD/GameContorls/SpeedUp").texture_normal = n_button
		get_node("HUD/GameContorls/SpeedDown").texture_normal = p_button


func _on_Play_pressed():
	Engine.set_time_scale(1.0)
	get_node("HUD/GameContorls/Play").texture_normal = p_button
	get_node("HUD/GameContorls/SpeedUp").texture_normal = n_button
	get_node("HUD/GameContorls/SpeedDown").texture_normal = n_button


func _on_SpeedUp_pressed():
	if Engine.get_time_scale() > 1.0:
		_on_Play_pressed()
	else:
		Engine.set_time_scale(2.0)
		get_node("HUD/GameContorls/Play").texture_normal = n_button
		get_node("HUD/GameContorls/SpeedUp").texture_normal = p_button
		get_node("HUD/GameContorls/SpeedDown").texture_normal = n_button

func _on_Cards_pressed():
	get_node("HUD/CardManager").visible = !get_node("HUD/CardManager").visible

func _on_TextureButton_pressed():
	get_node("HUD/InGameMenu").show()
