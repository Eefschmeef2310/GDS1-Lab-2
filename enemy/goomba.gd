extends Ground_Enemy

@export var animated_sprite_2d : AnimatedSprite2D
@export var collision_shape_2d : CollisionShape2D
@export var hurtHitbox : Area2D
@export var directionHithox : Area2D
@export var stompHitbox : Area2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") && !dying:
		GameManager.spawn_score_or_1up_popup(global_position)
		startDying()
		body.stomp_sequence += 1
		
		body.velocity.y = stompLanchHeight
		
	#if "shelled" in body.get_parent():
		#if body.shelled: 
			#GameManager.spawn_score_or_1up_popup(global_position)
			#startDying()
	#if "is_exploding" in body:
		#startDying()

func startDying():
	$AudioStreamPlayer.play()
	dying = true
	animated_sprite_2d.set_animation("dead")
	collision_shape_2d.set_deferred("disabled",true)
	hurtHitbox.set_deferred("monitorable", false)
	stompHitbox.set_deferred("monitorable", false)
	directionHithox.set_deferred("monitorable", false)
	hurtHitbox.set_deferred("disabled", true)
	stompHitbox.set_deferred("disabled", true)
	directionHithox.set_deferred("disabled", true)
	
func _on_direction_hitbox_body_entered(_body):
	ChangeDirection()

func Activate():
	activated = 1
	
func _on_hurt_hitbox_body_entered(body):
	if body.is_in_group("player") && !dying: # replace false with if player is invincible
		if !body.is_star() and !body.is_invincible():
			body.hurt()
		else:
			GameManager.spawn_score_or_1up_popup(global_position)
			startDying()
		
