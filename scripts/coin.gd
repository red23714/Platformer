extends Area2D

@onready var animation_player = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	animation_player.play("pickup")
	
	if body.get_node("HookController").target_obj == self:
		body.get_node("HookController").retract()
	GameManager.add_coin()
