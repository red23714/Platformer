extends AnimatableBody2D

@export var moveable: bool = false

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D

var is_player_on_top : bool = false

func _ready():
	set_meta("moveable", moveable)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("down") and is_player_on_top:
		collision_shape_2d.set_deferred("disabled", true)


func _on_area_2d_body_entered(_body: Node2D) -> void:
	is_player_on_top = true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	if is_player_on_top:
		collision_shape_2d.set_deferred("disabled", false)
		is_player_on_top = false
