extends Control

func _ready():
	GameManager.reset()
	
	UI.loading_screen = true
	UI.underground = false
	UI.update_coin()
	UI.coin_animation.speed_scale = 1
	
	$"Top Score".text = "TOP-" + str(SaveManager.save_game.high_score).pad_zeros(7)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://levels/loading_screen.tscn")
