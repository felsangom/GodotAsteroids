extends Node2D

func _ready():
	$CanvasLayer/Pontos.text = str(Global.score)

func _on_Restart_pressed():
	Global.goto_scene("res://scenes/MainGame.tscn")
