extends Node

var TowerPreview = null

var total_cards

var tower_buf ={
	"dmg_mlt": 1.0,
	"pierce": 0,
	"range_mlt": 1.0,
}

# wave settings
# 
# wave_id: [spawner_id, enemy_type, count, multiplier]  **(can be, delay)

var wave = {
	"map_1":{
		0:[[0, "Base_Enemy", 3, 5], [0, "Base_Enemy", 2, 5]],
	}
}


# Card BD
# 
# card_id: [name, description, price, type_arr, value_arr]
# 0001: ["demo", "demo desc", 100, [type1, [func1*], type2, [func2*]],[ [10,20], [5] ]
# type  "onDraw" ; "onUse" ; "onDiscard"

var card = {
#	economy cards
	0:["test", "on Draw get resource", 0, ["onDraw", ["resource", "resource"]], [ 20, 100 ] ],
	1:["test", "on Use get resource", 20, ["onUse", ["resource"]], [ 100 ] ],
	2:["test", "on Discard get resource", 20, ["onDiscard", ["resource"]], [ 100 ] ],
#	military cards
	3:["test", "dmg_mlt", 20, ["onUse", ["dmg_mlt"]], [ .1 ] ],
	4:["test", "pierce", 20, ["onUse", ["pierce"]], [ 1 ] ],
	5:["test", "range_mlt", 20, ["onUse", ["range_mlt"]], [ .1 ] ],
	
}
