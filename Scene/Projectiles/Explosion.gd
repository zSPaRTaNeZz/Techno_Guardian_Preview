extends RigidBody2D

var damage

func _ready():
	pass

func _on_Area2D_body_entered(body):
	body.on_hit(damage)
	yield(get_tree().create_timer(0.1),"timeout")
	self.queue_free()

