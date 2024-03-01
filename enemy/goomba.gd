extends Ground_Enemy

@export var animated_sprite_2d : AnimatedSprite2D
@export var collision_shape_2d : CollisionShape2D
@export var hurtHitbox : Area2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") && !dying:
		startDying()
		
		body.velocity.y = stompLanchHeight
	if "shelled" in body.get_parent():
		if body.shelled == true: 
			startDying()
	#if "is_exploding" in body:
		#startDying()

func startDying():
	dying = true
	animated_sprite_2d.set_animation("dead")
	collision_shape_2d.set_deferred("disabled",true)
	
func _on_direction_hitbox_body_entered(_body):
	#if !body.is_in_group("player"):
	scale.x *= -1
	direction *= -1

func Activate():
	activated = 1
	
func _on_hurt_hitbox_body_entered(body):
	if body.is_in_group("player") && !dying: # replace false with if player is invincible
		if !body.is_star() and !body.is_invincible():
			body.hurt()
		else:
			startDying()
