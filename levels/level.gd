extends Node2D

func _ready():
	GameManager.timer.start(160)
	UI.underground = false
	UI.update_coin()
