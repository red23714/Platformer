extends Node2D

const SPEED : int = 60

var direction : int = 1

var health : int = 2

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	position.x += direction * SPEED * delta
	
func take_damage(damage: int):
	health -= damage
	
	animated_sprite.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	animated_sprite.modulate = Color.WHITE
	
	if health <= 0:
		call_deferred("queue_free")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && health > 0 && body.get_node("HookController").target_obj != self:
		body.take_damage(0.5)
