extends Node

var base_distance = 20
var spawn_points = []
# enemy_array.append(body)

func _ready():
	get_spawn_points()
#	spawn_points[0].delete()

func get_spawn_points():
	var node = get_node("SpawnPoints")
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		spawn_points.append(child)

func spawn_enemies(wave_data):
	for i in wave_data:
		for j in i[3]:
			var rand_pos = rand_range(-20.0 , 20.0)
			var distance = -0.5* base_distance * (i[2] - 1)
			for k in i[2]:
				var new_enemy = load("res://Scene/Enemy/" + i[1] + ".tscn").instance()
				new_enemy.position = spawn_points[i[0]].position + Vector2(distance + rand_pos, 0)
				distance += base_distance
				new_enemy.direction = spawn_points[i[0]].direction
				get_node("Enemies").add_child(new_enemy, true)
			yield(get_tree().create_timer(0.5),"timeout")
		yield(get_tree().create_timer(2.0),"timeout")
