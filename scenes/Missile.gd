extends Area2D

signal destroy_asteroid

export (int) var speed = 500
var velocity = Vector2()

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed

func _process(delta):
	position += velocity * delta

func _on_Missile_body_entered(body):
	if body.is_in_group('asteroids'):
		queue_free()
		emit_signal('destroy_asteroid', body)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
