extends TextureRect

var heart_size: int = 36

func _ready():
	GameManager.player.health_changed.connect(update)
	update()

func update():
	size.x = GameManager.player.health * heart_size
