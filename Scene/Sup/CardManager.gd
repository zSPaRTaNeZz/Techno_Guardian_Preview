extends HBoxContainer

var GameScene

func _ready():
	GameScene = get_node("../../..")

func Generate_card(amount):
	for i in amount:
		var card = load("res://Scene/Sup/CardTemplate.tscn").instance()
		var rand = randi() % Global.total_cards
		card.card_id = rand
		add_child(card, true)

func cards_destroy():
	for i in range(self.get_child_count()):
		self.get_child(i).card_discard()

func get_spawn_points():
	var node = get_node("SpawnPoints")
	for i in range(node.get_child_count()):
		var child = node.get_child(i)

func resource(arr, price):
	if GameScene.influence < price:
#		error sound
		return false
	else:
		GameScene.add_resources(arr, -price)
		return true

func add_dmg(arr, price):
	if GameScene.influence < price:
#		error sound
		return false
	else:
		Global.tower_buf["dmg_mlt"] += arr
		GameScene.add_resources(0, -price)
		return true

func pierce(arr, price):
	if GameScene.influence < price:
#		error sound
		return false
	else:
		Global.tower_buf["pierce"] += arr
		GameScene.add_resources(0, -price)
		return true

func range_mlt(arr, price):
	if GameScene.influence < price:
#		error sound
		return false
	else:
		Global.tower_buf["range_mlt"] += arr
		GameScene.add_resources(0, -price)
		return true
