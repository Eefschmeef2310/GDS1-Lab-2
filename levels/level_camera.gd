extends Camera2D

@export var player: CharacterBody2D

func _physics_process(_delta):
	if(player != null):
		global_position.x = max(global_position.x, player.global_position.x)
