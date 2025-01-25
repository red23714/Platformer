extends CharacterBody2D

const SPEED = 260.0
const JUMP_VELOCITY = -300.0

var deceleration: float = 1.0

var is_fly : bool = false

var is_alive : bool = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hook_controller: Node2D = $HookController

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_alive:
		# Handle jump.
		if Input.is_action_just_pressed("jump") && (is_on_floor() || hook_controller.launched):
			velocity.y += JUMP_VELOCITY
			hook_controller.retract()
		
		# Flip sprite
		if velocity.x > 0:
			animated_sprite.flip_h = false
		elif velocity.x < 0:
			animated_sprite.flip_h = true
		
		# Play animations
		if is_on_floor():
			animated_sprite.play("idle")
		elif !hook_controller.launched:
			animated_sprite.play("jump")
		
		# Get input direction: -1, 0, 1
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED * int(is_fly)
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
