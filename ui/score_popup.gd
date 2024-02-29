extends Control

@onready var score = $Score

func set_values(value : int, pos : Vector2):
	$Score.text = str(value)
	global_position = pos
