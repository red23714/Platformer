extends Marker2D

@export var time_to_spawn: float = 2.0
@export var trigger_area: int = 100
@export var enemy: PackedScene

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = time_to_spawn
	timer.start()

func _on_timer_timeout() -> void:
	var instance = enemy.instantiate()
	
	instance.global_position = global_position

	instance.top_level = true
	add_child(instance)
	#timer.stop()
