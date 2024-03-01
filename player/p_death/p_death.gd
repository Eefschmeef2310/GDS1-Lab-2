extends Node2D


# Called when the node enters the scene tree for the first time.
func _on_timer_timeout():
	get_tree().paused = false
	
	if GameManager.lives <= 0:
		get_tree().change_scene_to_file("res://levels/game_over.tscn")
	else:
		GameManager.restart_level()
	
