extends Node2D

export (PackedScene) var Asteroid
export (PackedScene) var Explosion

func _ready():
	randomize()

func _on_Spaceship_shoot(missile, _position, _direction):
	var m = missile.instance()
	add_child(m)
	move_child(m, 0)
	m.start(_position, _direction)
	m.connect('destroy_asteroid', self, "_on_Asteroid_Destroy")

func _on_AsteroidTimer_timeout():
	spawn_asteroid()

func spawn_asteroid(start_scale:Vector2 = Vector2(1, 1), start_position:Vector2 = Vector2.ZERO, small:bool = false):
	# Create asteroid at random location
	$AsteroidGenerationPath/AsteroidGenerationPlace.offset = randi()
	var asteroid = Asteroid.instance()
	asteroid.small = small
	asteroid.get_node('Sprite').scale = start_scale
	asteroid.get_node('CollisionShape').scale = start_scale
	add_child(asteroid)

	var direction = $AsteroidGenerationPath/AsteroidGenerationPlace.rotation + PI / 2
	if start_position.length() == 0:
		asteroid.position = $AsteroidGenerationPath/AsteroidGenerationPlace.position
	else:
		asteroid.position = start_position

	direction += rand_range(-PI / 4, PI / 4)
	asteroid.linear_velocity = Vector2(rand_range(asteroid.min_speed, asteroid.max_speed), 0)
	asteroid.linear_velocity = asteroid.linear_velocity.rotated(direction)

func _on_Asteroid_Destroy(asteroid):
	var is_small_asteroid = asteroid.small
	asteroid.get_node('CollisionShape').set_deferred("disabled", true)
	var asteroid_position = asteroid.global_position
	var asteroid_scale = asteroid.scale
	asteroid.destroy()

	var explosion = Explosion.instance()
	explosion.position = asteroid_position
	add_child(explosion)
	$ExplosionSound.play()
	explosion.explode()

	if !is_small_asteroid:
		var smaller_asteroids = 0
		while smaller_asteroids < 3:
			spawn_asteroid(asteroid_scale / 2, asteroid_position, true)
			smaller_asteroids += 1


func _on_Spaceship_took_damage():
	$SpaceshipHealth.value = $Spaceship.health
