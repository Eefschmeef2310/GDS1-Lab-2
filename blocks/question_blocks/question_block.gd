extends Block
class_name QuestionBlock

@onready var animation_player = $AnimationPlayer

@export var COIN : PackedScene = preload("res://blocks/coin_popup.tscn")

@export var item_type : Item.ItemType
var item_scene : PackedScene = preload("res://item/item.tscn")

@export var max_hits : int = 1
var hits : int = 0

func _on_player_hit_box_body_entered(body):
	if body.is_in_group("player") and hits < max_hits and body.velocity.y < 50:
		if item_type == Item.ItemType.NULL:
			var coin = COIN.instantiate()
			coin.global_position = $CoinMarker.global_position
			get_tree().root.call_deferred("add_child", coin)
		else:
			#Set flower if player is big automagically
			if item_type == Item.ItemType.MUSHROOM and (body.powerup_state == PlayerController.PowerupState.BIG or body.powerup_state == PlayerController.PowerupState.FIRE):
				item_type = Item.ItemType.FLOWER
				
			var item = item_scene.instantiate()
			item.item_type = item_type
			item.global_position = $CoinMarker.global_position
			get_tree().root.call_deferred("add_child", item)
		
		hits += 1
		if hits == max_hits:
			animation_player.play("hit")
		
		super.bump()
	elif hits >= max_hits:
		$Bump.play()
