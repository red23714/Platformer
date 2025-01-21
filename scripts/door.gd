extends Area2D

@export var next_level_name : String

func _on_body_entered(body: Node2D) -> void:
	print("fuck")
	if body.is_in_group("Player"):
		GameManager.goto_scene("res://levels/" + next_level_name + ".tscn")
