extends Node2D

func _on_body_entered(body):
	if(body.is_in_group("player")):
		GameManager.collect_coin()
		queue_free()
