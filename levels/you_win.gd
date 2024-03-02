extends Control

func _ready():
	SaveManager.update_score(GameManager.score)
	SaveManager.save()
	
	UI.loading_screen = true
	UI.update_coin()
	UI.coin_animation.speed_scale = 0

func _on_audio_stream_player_finished():
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
