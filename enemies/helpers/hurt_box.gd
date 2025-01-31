class_name HurtBox

extends Area2D

@export var health : int = 2
@export var animated_sprite: AnimatedSprite2D
@export var moveable: bool = true

func _ready() -> void:
	set_meta("moveable", moveable)

func take_damage(damage: int):
	health -= damage
	
	animated_sprite.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	animated_sprite.modulate = Color.WHITE
	
	if health <= 0:
		owner.call_deferred("queue_free")
