extends QuestionBlock

func _on_player_hit_box_body_entered(body):
	print("bingus")
	call_deferred("turn_off_collision")
	super._on_player_hit_box_body_entered(body)
	
func turn_off_collision():
	$CollisionShape2D.one_way_collision = false
