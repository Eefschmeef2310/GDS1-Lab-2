extends Area2D

func _on_body_entered(body):
	if(body.is_in_group("player")):
		body.get_death_controller().oob_kill_player()
