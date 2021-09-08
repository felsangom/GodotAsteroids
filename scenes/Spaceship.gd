extends KinematicBody2D

signal shoot
signal took_damage

export (int) var health = 100
export (int) var speed = 200
export (int) var push_force = 50
export (float) var acceleration = 0.5
export (float) var friction = 0.1
export (float) var rotation_speed = 3
export (PackedScene) var Missile

var velocity = Vector2()
var rotation_direction = 0
var animate = false
var can_shoot = true
var can_take_damage = true

func _ready():
	position = get_viewport_rect().size / 2

func get_input():
	animate = false
	rotation_direction = 0

	if Input.is_action_pressed("ui_right"):
		rotation_direction += 1
	elif Input.is_action_pressed("ui_left"):
		rotation_direction -= 1

	if Input.is_action_pressed("ui_up"):
		animate = true
		velocity = Vector2(speed, 0).rotated(rotation)

	if Input.is_action_pressed("ui_accept"):
		if can_shoot:
			shoot()

func shoot():
	can_shoot = false
	$MissileCooldown.start()

	var direction = Vector2(1, 0).rotated(global_rotation)
	emit_signal('shoot', Missile, global_position, direction)

func took_damage():
	health -= 25
	emit_signal('took_damage')

func _physics_process(delta):
	get_input()

	if animate:
		$AnimatedSprite.play("throttle")
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
		$AnimatedSprite.play("idle")

	rotation += rotation_direction * rotation_speed * delta
	velocity = move_and_slide(velocity, Vector2.ZERO, false, 4, PI / 4, false)
	check_collision()

func check_collision():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if (collision.collider.is_in_group("asteroids")):
			collision.collider.apply_central_impulse(-collision.normal * push_force)
			if (can_take_damage):
				collided()


func collided():
	if (health >= 25):
		$TookDamageSound.play()
		took_damage()
		can_take_damage = false
		$DamageCooldown.start()
	else:
		# Game over
		pass

func _on_MissileCooldown_timeout():
	can_shoot = true

func _on_DamageCooldown_timeout():
	can_take_damage = true
