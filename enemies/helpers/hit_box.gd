class_name HitBox

extends Area2D

@export var damage : float = 10

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	collision_mask = GameManager.player.collision_layer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && body.get_node("HookController").target_obj != self:
		if(damage > 0.0):
			body.take_damage(damage)
		else: 
			body.kill()
