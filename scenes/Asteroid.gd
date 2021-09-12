extends Node2D

var sprites = [
	preload("res://assets/images/asteroid_1.png"),
	preload("res://assets/images/asteroid_2.png"),
	preload("res://assets/images/asteroid_3.png"),
	preload("res://assets/images/asteroid_4.png"),
	preload("res://assets/images/asteroid_5.png"),
	preload("res://assets/images/asteroid_6.png")
]

export (bool) var small = false
export (int) var min_speed = 150
export (int) var max_speed = 250
export (int) var rotation_speed = 3
var rotation_direction = 0

func spawn():
	# Set texture
	var sprite_image = sprites[randi() % sprites.size()]
	$Sprite.texture = sprite_image

	var sprite_name = sprite_image.resource_path.get_file()
	if sprite_name == 'asteroid_1.png':
		$CollisionShape.shape = $Asteroid1CollisionShape.shape
	elif sprite_name == 'asteroid_2.png':
		$CollisionShape.shape = $Asteroid2CollisionShape.shape
	elif sprite_name == 'asteroid_3.png':
		$CollisionShape.shape = $Asteroid3CollisionShape.shape
	elif sprite_name == 'asteroid_4.png':
		$CollisionShape.shape = $Asteroid4CollisionShape.shape
	elif sprite_name == 'asteroid_5.png':
		$CollisionShape.shape = $Asteroid5CollisionShape.shape
	elif sprite_name == 'asteroid_6.png':
		$CollisionShape.shape = $Asteroid6CollisionShape.shape

	# Randon rotation direction
	rotation_direction = 1
	if (randi() * 2) % 1 == 0:
		rotation_direction = rotation_direction * -1

func _ready():
	spawn()

func destroy():
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
