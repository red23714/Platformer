extends Camera2D

const DEAD_ZONE : int = 160

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var _target = event.position - get_viewport().size * 0.5
		if _target.length() < DEAD_ZONE:
			self.position = Vector2.ZERO
		else:
			self.position = _target.normalized() * (_target.length() - DEAD_ZONE) * 0.1
