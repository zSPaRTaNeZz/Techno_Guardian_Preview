extends Node2D

var health = 100


func _ready():
	pass # Replace with function body.


func on_hit(damage):
	health -= damage
	if health <= 0:
		on_destroy()

func on_destroy():
#	get_node("StaticBody2D").queue_free()
#	yield(get_tree().create_timer(0.2), "timeout")
#	self.queue_free()
#	get_parent().get_parent().Game_Over()
	pass
