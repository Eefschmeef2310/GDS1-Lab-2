extends Node2D


# Called when the node enters the scene tree for the first time.
func _on_timer_timeout():
	get_tree().paused = false
	GameManager.restart_level()
