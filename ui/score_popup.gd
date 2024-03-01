extends Control

func set_values(value : int, pos : Vector2):
	$Score.text = str(value)
	global_position = pos
	GameManager.increase_score(value)
