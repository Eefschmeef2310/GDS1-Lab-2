extends CharacterBody2D

const UP_POPUP = preload("res://ui/1up_popup.tscn")

enum ItemType {
	MUSHROOM,
	FLOWER,
	STAR,
	LIFE
}
@export var item_type = ItemType.MUSHROOM
var move_speed = 60

func _ready():
	if item_type != ItemType.FLOWER:
		velocity.x = move_speed

func _physics_process(delta):
	velocity.y += 5
	
	if item_type == ItemType.STAR and is_on_floor():
		velocity.y = -125
	if is_on_wall():
		velocity.x = get_last_slide_collision().get_normal().x * move_speed
		
	move_and_slide()
	
	match item_type:
		ItemType.MUSHROOM:
			$AnimationPlayer.play("mushroom")
		ItemType.FLOWER:
			$AnimationPlayer.play("flower")
		ItemType.STAR:
			$AnimationPlayer.play("star")
		ItemType.LIFE:
			$AnimationPlayer.play("1up")


func _on_player_hit_box_body_entered(body):
	if body != self and body.is_in_group("player"):
		match item_type:
			ItemType.MUSHROOM:
				body.change_powerup("mushroom")
				queue_free()
			ItemType.FLOWER:
				body.change_powerup("fire")
				queue_free()
			ItemType.STAR:
				# Start invincibility
				pass
			ItemType.LIFE:
				var popup = UP_POPUP.instantiate()
				popup.global_position = global_position
				get_tree().root.add_child(popup)
				GameManager.gain_1up()
				queue_free()
				pass
