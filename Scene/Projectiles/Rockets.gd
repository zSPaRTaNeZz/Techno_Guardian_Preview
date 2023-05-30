extends "res://Scene/Projectiles/Bullet.gd"


func _on_Area2D_body_entered(body):
	if hit:
		hit = false
		var explosion = load("res://Scene/Projectiles/Explosion.tscn").instance()
		explosion.position = global_transform.origin
		explosion.damage = damage
		get_parent().add_child(explosion)
		self.queue_free()

