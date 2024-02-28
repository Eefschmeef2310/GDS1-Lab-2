extends Block

@onready var animation_player = $AnimationPlayer

const COIN : PackedScene = preload("res://blocks/coin_popup.tscn")

var hit : bool = false

func _on_player_hit_box_body_entered(body):
	if body.is_in_group("player") and !hit:
		
		var coin = COIN.instantiate()
		coin.global_position = $CoinMarker.global_position
		get_tree().root.add_child(coin)
		
		animation_player.play("hit")
		hit = true
		
		super.bump()
	elif hit:
		$Bump.play()
		
