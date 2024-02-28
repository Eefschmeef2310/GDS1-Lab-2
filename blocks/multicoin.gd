extends QuestionBlock

func _on_player_hit_box_body_entered(body):
	if body.is_in_group("player") and hits < max_hits:
		$Timer.start(4)
		super._on_player_hit_box_body_entered(body)

func _on_timer_timeout():
	hits = max_hits - 1
