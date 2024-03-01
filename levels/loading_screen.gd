extends Control

func _ready():
	GameManager.reset()
	
	UI.loading_screen = true
	UI.update_coin()
	UI.coin_animation.speed_scale = 0
	
	$RichTextLabel.text = "[center][img]res://ui/sprites/mario.png[/img] [img=5]res://ui/sprites/x.png[/img]  " + str(GameManager.lives)

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://levels/level.tscn")
	UI.coin_animation.speed_scale = 1
