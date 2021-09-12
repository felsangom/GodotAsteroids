extends Node

var score = 0
var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
	call_deferred("_deffered_goto_scene", path)

func _deffered_goto_scene(path):
	current_scene.free()

	var new_scene = ResourceLoader.load(path)
	current_scene = new_scene.instance()

	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
