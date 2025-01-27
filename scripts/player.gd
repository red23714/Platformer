extends CharacterBody2D

signal health_changed

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var acceleration: float = 1.0
var deceleration: float = 1.0

@export var jump_height: float = 100
@export var jump_time_to_peak: float = 100
@export var jump_time_to_descent: float = 100

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var is_fly : bool = false

var max_health : float = 3
var health : float = max_health

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hook_controller: Node2D = $HookController
@onready var sword: Area2D = $Sword

func get_gravity_player() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func take_damage(amount: float):
	health -= amount
	
	animated_sprite.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	animated_sprite.modulate = Color.WHITE
	
	health_changed.emit()
	
	if health <= 0:
		GameManager.reload_scene()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity_player() * delta
	
	if health > 0:
		# Handle jump.
		if Input.is_action_just_pressed("jump") && (is_on_floor() || hook_controller.launched):
			velocity.y += JUMP_VELOCITY
			hook_controller.retract()
		
		# Flip sprite
		if velocity.x > 0:
			animated_sprite.flip_h = false
			sword.attack_animation = "attack"
		elif velocity.x < 0:
			animated_sprite.flip_h = true
			sword.attack_animation = "attack_left"
		
		# Get input direction: -1, 0, 1
		var direction := Input.get_axis("left", "right")
		
		# Play animations
		if is_on_floor():
			if direction != 0:
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")
		elif hook_controller.launched:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("jump")
		
		if direction:
			velocity.x = lerp(velocity.x, direction * SPEED * (1 + int(is_fly)), acceleration)
		else:
			velocity.x = lerp(velocity.x, 0.0, deceleration)
		
		var up_down := Input.get_axis("jump", "down")
		if is_fly:
			if up_down:
				velocity.y = up_down * SPEED * 2
			else:
				velocity.y = move_toward(velocity.y, 0, SPEED * 2)
		
		if Input.is_action_just_pressed("cheats"):
			is_fly = not is_fly
			$CollisionShape2D.set_deferred("disabled", not $CollisionShape2D.disabled)
			print("cheats: " + str(is_fly))
	
	move_and_slide()
