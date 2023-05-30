extends Node2D

var direction

func _ready():
	var Target = get_parent().get_parent().get_node("Base").position
	direction = Target - position
	direction = direction.normalized()

func delete():
	self.queue_free()

