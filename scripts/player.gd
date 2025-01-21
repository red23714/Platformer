extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var is_fly : bool = false

var is_alive : bool = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_alive:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		# Get input direction: -1, 0, 1
		var direction := Input.get_axis("left", "right")
		
		# Flip sprite
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		
		# Play animations
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")
		
		if direction:
			velocity.x = direction * SPEED * (1 + int(is_fly))
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
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
