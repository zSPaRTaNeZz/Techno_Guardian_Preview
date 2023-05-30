extends RigidBody2D

var speed = 500
var damage
var shoot_range
var hit = true
var pierce = 0

func _ready():
	# Change how long bullet exist 0.5 - exactly range of tower
	shoot_range = 0.5 * shoot_range
	start_move()
	yield(get_tree().create_timer(shoot_range/speed), "timeout")
	self.queue_free()

# randf_range(-PI / 4, PI / 4)
func start_move():
	var direction = deg2rad(rotation_degrees) 
	var velocity = Vector2(speed, 0.0)
	linear_velocity = velocity.rotated(direction)

func _on_Area2D_body_entered(body):
	if hit:
		if pierce < 1:
			hit = false
			self.queue_free()
		body.on_hit(damage)

