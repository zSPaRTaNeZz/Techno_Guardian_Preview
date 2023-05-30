extends RigidBody2D

var hp = 20
var velocity = 50
var damage = 10
var attack_cd = 1
var ready = true
var direction

#var Base

var Target_array = []
var Target

var attack_mode = false
var is_alive = true


func _ready():
	set_target()
	pass

func _physics_process(delta):
	if attack_mode == false:
		move(delta)
	elif ready:
		attack()
		attack_effect()

func set_target():
	Target = get_parent().get_parent().get_node("Base").position + Vector2(16, 16)

func on_hit(damage):
	hp -= damage
	# mb refresh hp bar
	if hp <= 0 and is_alive:
		is_alive = false
		on_destroy()

func on_destroy():
	get_parent().get_parent().get_parent().on_enemy_destroy()
	self.queue_free()

func move(delta):
#	var direction = Target - position
#	direction = direction.normalized()
	linear_velocity = direction * velocity

func attack():
	ready = false
	Target_array[0].get_parent().on_hit(damage)
	yield(get_tree().create_timer(attack_cd), "timeout")
	ready = true

func attack_effect():
	modulate = "ff0000"
	yield(get_tree().create_timer(0.2), "timeout")
	modulate = "ffffff"
	
	pass

func _on_Attack_range_body_entered(body):
	Target_array.append(body)
	linear_velocity = Vector2(0,0)
	attack_mode = true

func _on_Attack_range_body_exited(body):
	Target_array.erase(body)
	if Target_array.size() == 0 :
		attack_mode = false
