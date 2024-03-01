extends CharacterBody2D
class_name Item

const UP_POPUP = preload("res://ui/1up_popup.tscn")
const SCORE_POPUP = preload("res://ui/score_popup.tscn")

enum ItemType {
	MUSHROOM,
	FLOWER,
	STAR,
	LIFE,
	NULL
}
@export var item_type = ItemType.MUSHROOM
var move_speed = 60

var complete_animation : bool = false

func _ready():
	match item_type:
		ItemType.MUSHROOM:
			$AnimationPlayer.play("mushroom")
		ItemType.FLOWER:
			$AnimationPlayer.play("flower")
		ItemType.STAR:
			$AnimationPlayer.play("star")
		ItemType.LIFE:
			$AnimationPlayer.play("1up")

func complete():
	if item_type != ItemType.FLOWER:
		velocity.x = move_speed
	complete_animation = true

func _physics_process(delta):
	if complete_animation:
		velocity.y += 5
		
		if item_type == ItemType.STAR and is_on_floor():
			velocity.y = -125
		if is_on_wall():
			velocity.x = get_last_slide_collision().get_normal().x * move_speed
			
		move_and_slide()

func _on_player_hit_box_body_entered(body):
	if body != self and body.is_in_group("player"):
		#Create score pop-up (this is the same across all items thank god)
		if item_type != ItemType.LIFE:
			var score_popup = SCORE_POPUP.instantiate()
			score_popup.set_values(1000, global_position)
			get_tree().root.add_child(score_popup)
		
		match item_type:
			ItemType.MUSHROOM:
				body.change_powerup("mushroom")
				queue_free()
			ItemType.FLOWER:
				body.change_powerup("fire")
				queue_free()
			ItemType.STAR:
				body.start_star()
				queue_free()
			ItemType.LIFE:
				var popup = UP_POPUP.instantiate()
				popup.global_position = global_position
				get_tree().root.add_child(popup)
				GameManager.gain_1up()
				queue_free()
				pass
