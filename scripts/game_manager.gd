extends Node

var player

func reload_scene():
	call_deferred("_deferred_reload_scene")

func _deferred_reload_scene():
	get_tree().reload_current_scene()
