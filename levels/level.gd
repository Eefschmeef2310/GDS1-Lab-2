extends Node2D

@onready var player = $Player

func _ready():
	UI.underground = false
	UI.loading_screen = false
	GameManager.timer.start(160)
	UI.update_coin()
	
	if GameManager.level1_checkpoint:
		player.global_position = $"Checkpoint 1".global_position

func _on_checkpoint_1_body_entered(body):
	if body.is_in_group("player"):
		GameManager.level1_checkpoint = true
