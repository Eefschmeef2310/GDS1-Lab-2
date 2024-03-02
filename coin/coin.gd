extends Node2D

func _on_body_entered(body):
	if(body.is_in_group("player")):
		GameManager.collect_coin()
		GameManager.increase_score(200)
		queue_free()
