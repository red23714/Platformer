extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var attack_animation : String = "attack"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		animation_player.play(attack_animation)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		if owner.get_node("HookController").target_obj == area:
			area.take_damage(100)
			owner.get_node("HookController").retract()
		else:
			area.take_damage(1)
