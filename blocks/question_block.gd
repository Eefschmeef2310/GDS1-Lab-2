extends Block
class_name QuestionBlock

@onready var animation_player = $AnimationPlayer

@export var COIN : PackedScene = preload("res://blocks/coin_popup.tscn")

@export var max_hits : int = 1
var hits : int = 0

func _on_player_hit_box_body_entered(body):
	if body.is_in_group("player") and hits < max_hits and body.velocity.y < 50:
		var coin = COIN.instantiate()
		coin.global_position = $CoinMarker.global_position
		get_tree().root.add_child(coin)
		
		hits += 1
		if hits == max_hits:
			animation_player.play("hit")
		
		super.bump()
	elif hits >= max_hits:
		$Bump.play()
