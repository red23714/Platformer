extends TextureRect

@onready var player: CharacterBody2D = $"../../../Player"

var heart_size: int = 36

func _ready():
	player.health_changed.connect(update)
	update()

func update():
	print(player.health)
	position.x =  (get_viewport().get_visible_rect().size.x - player.health * heart_size) / 2
	size.x = player.health * heart_size
