extends Node2D

@export var rest_length: float = 2.0
@export var stifness: float = 25.0
@export var damping: float = 2.0

@onready var player := get_parent()
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var line: Line2D = $Line2D

var launched: bool = false
var target: Vector2
var target_obj: Object

func _process(delta: float) -> void:
	ray_cast.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("hook"):
		launch()
	if Input.is_action_just_released("hook"):
		retract()
	
	if launched:
		handle_hook(delta)

func launch():
	if ray_cast.is_colliding():
		launched = true
		target_obj = ray_cast.get_collider()
		target = ray_cast.get_collision_point()
		line.show()
		player.deceleration = 0.1

func retract():
	launched = false
	line.hide()
	target_obj = null
	target = Vector2.ZERO
	player.deceleration = 1.0

func handle_hook(delta):
	if target_obj.is_in_group("Enemy"):
		delta *= 2
	if target_obj.has_meta("movebale") and target_obj.get_meta("movebale"):
		target.x = target_obj.position.x
	var target_dir: Vector2 = player.global_position.direction_to(target) # Получаем нормированный вектор от игрока до цели
	var target_dist: float = player.global_position.distance_to(target)
	
	var displacement: float = target_dist - rest_length

	var force = Vector2.ZERO
	
	if displacement:
		var spring_force_magnitude: float = stifness * displacement
		var spring_force: Vector2 = target_dir * spring_force_magnitude
		
		var vel_dot: float = player.velocity.dot(target_dir) # Скалярное произведение
		var damping: Vector2 = -damping * vel_dot * target_dir
		
		force = spring_force + damping
		
	player.velocity += force * delta
	update_rope()
	
func update_rope():
	line.set_point_position(1, to_local(target))
