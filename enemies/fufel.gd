extends CharacterBody2D

@export var speed: int = 50
@export var jump_velocity: float = -170.0
@export var radius_attack: int = 25
@export var anger_radius: int = 500

@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var ray_cast_left: RayCast2D = $RayCastLeft

var previous_direction: int = 0

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += get_gravity().y * delta
		
	var distance = GameManager.player.global_position.x - global_position.x
	var direction = sign(distance)
	
	if direction != previous_direction:
		scale.x = -scale.y * direction
		previous_direction = direction
	
	if ray_cast_down.is_colliding():
		if ray_cast_left.is_colliding() && is_on_floor() && abs(distance) >= radius_attack && ray_cast_left.get_collider().get_class() == "TileMapLayer":
			velocity.y += jump_velocity
		
		if abs(distance) >= radius_attack && abs(distance) > 0.5:
			velocity.x = direction * speed
		else:
			velocity.x = 0.0
	else:
		velocity.x = 0.0
	# Move the enemy
	move_and_slide()
