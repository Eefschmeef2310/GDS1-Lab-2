extends Node2D


# Called when the node enters the scene tree for the first time.
func _on_timer_timeout():
	GameManager.restart_level()
