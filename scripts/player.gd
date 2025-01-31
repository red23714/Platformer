extends CharacterBody2D

signal health_changed

@export var jump_height: float = 70.0
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descent: float = 0.4

@export var hook_down_power: float = 50

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hook_controller: Node2D = $HookController
@onready var sword: Area2D = $Sword

const SPEED = 100.0

var acceleration: float = 1.0
var deceleration: float = 1.0

var cheats : bool = false

var max_health : float = 3
var health : float = max_health

func _enter_tree() -> void:
	GameManager.player = self

func get_gravity_player() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func take_damage(amount: float):
	health -= amount
	if health > 0:
		animated_sprite.modulate = Color.RED
		await get_tree().create_timer(0.2).timeout
		animated_sprite.modulate = Color.WHITE
		
		health_changed.emit()
	
	if health == 0:
		GameManager.reload_scene()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity_player() * delta
	
	if health > 0:
		# Handle jump.
		if Input.is_action_just_pressed("jump") && (is_on_floor() || hook_controller.launched):
			velocity.y += jump_velocity
			hook_controller.retract()
			
		if Input.is_action_pressed("down") && hook_controller.launched && !is_on_floor():
			hook_controller.move_down(delta)
		if Input.is_action_pressed("up") && hook_controller.launched:
			hook_controller.move_up(delta)
		
		# Get input direction: -1, 0, 1
		var direction := Input.get_axis("left", "right")
		
		# Flip sprite
		if direction > 0 || velocity.x > 0.01:
			animated_sprite.flip_h = false
			sword.attack_animation = "attack"
		elif direction < 0 || velocity.x < -0.01:
			animated_sprite.flip_h = true
			sword.attack_animation = "attack_left"
		
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
		
		if direction != 0:
			velocity.x = lerp(velocity.x, direction * SPEED * (1 + 2 * int(cheats)), acceleration)
		else:
			velocity.x = lerp(velocity.x, 0.0, deceleration)
		
		var up_down := Input.get_axis("up", "down")
		if cheats:
			if up_down:
				velocity.y = up_down * SPEED * 2
			else:
				velocity.y = move_toward(velocity.y, 0, SPEED * 2)
		
		if Input.is_action_just_pressed("cheats"):
			cheats = not cheats
			$CollisionShape2D.set_deferred("disabled", not $CollisionShape2D.disabled)
			print("cheats: " + str(cheats))
	
	move_and_slide()
