extends Area2D

@onready var timer: Timer = $Timer

var hooked: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_alive:
		if body.get_node("HookController").launched:
			hooked = body.get_node("HookController").target_obj.is_in_group("Enemy")
		if not hooked:
			body.get_node("CollisionShape2D").queue_free()
			body.is_alive = false
		else:
			body.get_node("HookController").retract()
		timer.start()

func _on_timer_timeout() -> void:
	if hooked:
		get_parent().call_deferred("queue_free")
	else:
		get_tree().reload_current_scene()
