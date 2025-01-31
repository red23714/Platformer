extends Node2D

@export var rest_length: float = 1.0
@export var stifness: float = 50.0
@export var damping: float = 10.0

@export var down_power: float = 80.0

@onready var player := get_parent()
@onready var sprite: Sprite2D = $Sprite2D
@onready var ray_cast_main: RayCast2D = $RayCastMain
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var line: Line2D = $Line2D

var launched: bool = false
var target: Vector2
var target_obj: Object

func _process(delta: float) -> void:
	ray_cast_main.look_at(get_global_mouse_position())
	ray_cast_right.look_at(get_global_mouse_position())
	ray_cast_left.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("hook"):
		launch()
	if Input.is_action_just_released("hook"):
		retract()
	
	if launched:
		handle_hook(delta)

func launch():
	var raycast_coliding : RayCast2D
	if ray_cast_main.is_colliding():
		raycast_coliding = ray_cast_main
	elif ray_cast_right.is_colliding():
		raycast_coliding = ray_cast_right
	elif ray_cast_left.is_colliding():
		raycast_coliding = ray_cast_left
	
	if raycast_coliding:
		launched = true
		target_obj = raycast_coliding.get_collider()
		target = raycast_coliding.get_collision_point()
		line.show()
		sprite.show()
		player.acceleration = 0.1
		player.deceleration = 0.1

func retract():
	launched = false
	line.hide()
	sprite.hide()
	target_obj = null
	target = Vector2.ZERO
	rest_length = 1.0
	damping = 10.0
	player.acceleration = 1.0
	player.deceleration = 1.0

func handle_hook(delta):
	if target_obj is HurtBox:
		delta *= 4
	if target_obj.has_meta("moveable") && target_obj.get_meta("moveable"):
		target.x = target_obj.global_position.x
	var target_dir: Vector2 = player.global_position.direction_to(target) # Получаем нормированный вектор от игрока до цели
	var target_dist: float = player.global_position.distance_to(target)
	
	var displacement: float = target_dist - rest_length

	var force = Vector2.ZERO
	
	if displacement:
		var spring_force_magnitude: float = stifness * displacement
		var spring_force: Vector2 = target_dir * spring_force_magnitude
		
		var vel_dot: float = player.velocity.dot(target_dir) # Скалярное произведение
		var damping_2: Vector2 = -damping * vel_dot * target_dir
		
		force = spring_force + damping_2
	
	if rest_length < target_dist:
		player.velocity += force * delta
	update_rope()
	
func update_rope():
	line.set_point_position(1, to_local(target))
	sprite.position = to_local(target)
	if abs(get_angle_to(target)) > deg_to_rad(90):
		sprite.flip_v = true
	else:
		sprite.flip_v = false
	sprite.rotation = get_angle_to(target)
	
func move_down(delta):
	rest_length += down_power * delta
func move_up(delta):
	if rest_length >= 1.0:
		rest_length -= down_power * delta
