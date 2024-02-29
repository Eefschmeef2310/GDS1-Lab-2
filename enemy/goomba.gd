extends Ground_Enemy


@export var animated_sprite_2d : AnimatedSprite2D
@export var collision_shape_2d : CollisionShape2D






func _on_area_2d_body_entered(body):
	if body.is_in_group("player") && !dying:
		dying = true
		animated_sprite_2d.set_animation("dead")
		collision_shape_2d.set_deferred("disabled",true)
		
		body.velocity.y = -300


func _on_direction_hitbox_body_entered(body):
	if !body.is_in_group("player"):
		scale.x *= -1
		direction *= -1
