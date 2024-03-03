extends Area2D

const FLAG_SCORE_POPUP = preload("res://ui/flag_score_popup.tscn")

@export var point_value : int

func create_points():
	var popup = FLAG_SCORE_POPUP.instantiate()
	popup.set_values(point_value, position)
	get_parent().add_child(popup)
