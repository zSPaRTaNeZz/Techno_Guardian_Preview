extends TextureButton

var card_id = 0
var price
var value_arr
var types

# card_id: [name, description, price, type, value_arr]
func _ready():
	var val = Global.card[card_id]
	get_node("Name/Label").text = val[0]
	get_node("Description/Label").text = val[1]
	price = val[2]
	get_node("Price/Label").text = str(price)
	types = val[3]
	value_arr = val[4]
	
	var i = 0
	var k = 0
	while i < types.size():
		if types[i] == "onDraw":
			for j in types[i+1].size():
				use_card(types[i+1][j], value_arr[k], 0)
				k += 1
			break
		else:
			k +=types[i+1].size()
		i += 2

func use_card(function, value, price):
	if function == "resource":
		return get_parent().resource(value, price)
	if function == "dmg_mlt":
		return get_parent().add_dmg(value, price)
	if function == "pierce":
		return get_parent().pierce(value, price)
	if function == "range_mlt":
		return get_parent().range_mlt(value, price)

func card_discard():
	var i = 0
	var k = 0
	while i < types.size():
		if types[i] == "onDiscard":
			for j in types[i+1].size():
				use_card(types[i+1][j], value_arr[k], 0)
				k += 1
			break
		else:
			k +=types[i+1].size()
		i += 2
	self.queue_free()


func _on_CardTemplate_pressed():
	var i = 0
	var k = 0
	var t_price = price
	var delete = false
	while i < types.size():
		if types[i] == "onUse":
			for j in types[i+1].size():
				if use_card(types[i+1][j], value_arr[k], t_price):
					t_price = 0
					delete = true
				k += 1
			if delete:
				self.queue_free()
			break
		else:
			k +=types[i+1].size()
		i += 2

