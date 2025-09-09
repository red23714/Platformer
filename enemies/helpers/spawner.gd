extends Area2D

@export var time_to_spawn: float = 2.0
@export var max_enemy: int = 10
@export var enemy: PackedScene
@export var disabled: bool = false

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = time_to_spawn
	timer.start()

func _on_timer_timeout() -> void:
	var bodies = get_overlapping_bodies()
	if(bodies.size() < max_enemy && !disabled):
		var instance = enemy.instantiate()
		
		instance.global_position = global_position

		instance.top_level = true
		add_child(instance)
		#timer.stop()
