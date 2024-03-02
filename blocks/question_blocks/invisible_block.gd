extends QuestionBlock

func _on_player_hit_box_body_entered(body):
	if body.velocity.y < 50:
		call_deferred("turn_off_collision")
	super._on_player_hit_box_body_entered(body)
	
func turn_off_collision():
	$CollisionShape2D.disabled = false
