extends Node2D


var enemy_array = []
var enemy

var projectile
var health
var base_damage
var damage
var price
var pierce = 0

var rof
var angle
var base_range
var attack_range

var ready = true
var build = false

func _init():
	set_param()
	update_param()

func _ready():
	if build:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * attack_range

func set_param():
	projectile = "Bullet"
	health = 100
	base_damage = 10
	price = 20
	rof = 0.1
	angle = PI / 6
	base_range = 300.0

func update_param():
	pierce = Global.tower_buf["pierce"]
	damage = Global.tower_buf["dmg_mlt"] * base_damage
	attack_range = Global.tower_buf["range_mlt"] * base_range 


func _physics_process(delta):
#	if enemy_array.size() != 0 and build:	
	if enemy_array.size() != 0 and build:
		select_enemy()
		turn()
		if ready:
			fire()
	else: 
		enemy = null

#func _unhandled_input(event):
#	if event.is_action_released("ui_cancel"):
#		print("1")
##		print(GameData.build_state)
#	if event.is_action_released("ui_accept"):
#		print("1")

func turn():
	get_node("Turret").look_at(enemy.position)

func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(position.distance_to(i.position))
		pass
	var min_distance = enemy_progress_array.min()
	var enemy_index = enemy_progress_array.find(min_distance)
	enemy = enemy_array[enemy_index]

func fire():
	ready = false
#	if category == "Projectile":
#		fire_gun()
#	elif category == "Missile":
#		fire_missile()
	var bullet = load("res://Scene/Projectiles/" + projectile + ".tscn").instance()
	bullet.position = position + get_node("Turret").position
	bullet.rotation = get_node("Turret").rotation + rand_range(-angle / 2, angle / 2)
	bullet.shoot_range = attack_range
	bullet.damage = damage
	bullet.pierce = pierce
	get_parent().get_parent().get_node("Projectile").add_child(bullet)
#	get_parent().add_child(bullet)
	#enemy.on_hit(damage)
	yield(get_tree().create_timer(rof), "timeout")
	ready = true

func on_hit(damage):
	health -= damage
	if health <= 0:
		on_destroy()

func on_destroy():
	get_node("StaticBody2D").queue_free()
#	yield(get_tree().create_timer(0.2), "timeout")
	self.queue_free()

func _on_Range_body_entered(body):
	enemy_array.append(body)

func _on_Range_body_exited(body):
	enemy_array.erase(body)
