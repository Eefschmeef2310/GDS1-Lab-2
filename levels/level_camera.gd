extends Camera2D

@onready var player = $"../CharacterBody2D"

func _process(_delta):
	global_position.x = max(global_position.x, player.global_position.x)
