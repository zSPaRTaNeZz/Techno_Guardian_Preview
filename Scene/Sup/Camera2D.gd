extends Camera2D


var zoom_min = Vector2(.5,.5)
var zoom_max = Vector2(1,1)
var zoom_speed = Vector2(.1,.1)


func _ready():
	position = get_viewport_rect().size/2

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_MIDDLE:
			position -= event.relative * zoom
			position_check()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				zoom_in()
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom_out()

func zoom_in():
	if zoom > zoom_min:
		zoom -= zoom_speed
		position_check()
		tower_preview_check()
		
func zoom_out():
	if zoom < zoom_max:
		zoom += zoom_speed
		position_check()
		tower_preview_check()

# Set limit to camera position
func position_check():
	if position[0] < get_viewport_rect().size[0] / 2 * zoom[0]:
		position[0] = (get_viewport_rect().size)[0] / 2 * zoom[0]
	if position[1] < get_viewport_rect().size[1] / 2 * zoom[1]:
		position[1] = (get_viewport_rect().size)[1] / 2 * zoom[1]

	if position[0] > get_viewport_rect().size[0] - get_viewport_rect().size[0] / 2 * zoom[0]:
		position[0] = get_viewport_rect().size[0] - get_viewport_rect().size[0] / 2 * zoom[0]
	if position[1] > get_viewport_rect().size[1] - get_viewport_rect().size[1] / 2 * zoom[1]:
		position[1] = get_viewport_rect().size[1] - get_viewport_rect().size[1] / 2 * zoom[1]

func tower_preview_check():
	if Global.TowerPreview != null:
		get_parent().get_node("UI/TowerPreview").rect_scale = Vector2(1.0, 1.0) / zoom

