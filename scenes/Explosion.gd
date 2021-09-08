extends Node2D

var exploded = false

func explode():
	$Particles2D.emitting = true
	exploded = true

func _process(delta):
	if exploded && !$Particles2D.emitting:
		queue_free()
