extends Node

signal touched_flag()

var player_win_scene = preload("res://player/p_win/mario_win.tscn")

func _on_flag_collision_area_entered(area):
	if (area.get_parent().is_in_group("flag")):
		
		GameManager.timer.paused = true
		
		var player_win = player_win_scene.instantiate()
		get_parent().get_parent().call_deferred("add_child", player_win)
		player_win.global_position = get_parent().global_position
		player_win.powerup_state = get_parent().powerup_state
		
		touched_flag.emit()
		if "create_points" in area : area.create_points()

		GameManager.stop_playing_music()
		get_parent().queue_free()
