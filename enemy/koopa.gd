extends Ground_Enemy

@export var animated_sprite_2d : AnimatedSprite2D
@export var collision_shape_2d : CollisionShape2D

var shelled : bool = false
@export var shellRecoverTime : float = 5
var recoverTimer : float = 0
@export var shellSpeed = 300

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if !shelled:
			shelled = true
			animated_sprite_2d.set_animation("shell")
			direction = 0
		else:
			if direction == 0:
				direction = 1
				speed = shellSpeed
				
			else:
				direction = 0
				
		
		
		#collision_shape_2d.set_deferred("disabled",true)
		
		body.velocity.y = stompLanchHeight

func _on_direction_hitbox_body_entered(body):
	ChangeDirection()
	if shelled:
		if body.get_parent().has_method("startDying") : body.get_parent().startDying()

func Activate():
	activated = 1
	
func _on_hurt_hitbox_body_entered(body):
	#print (body)
	if body.is_in_group("player"): # replace false with if player is invicinble
		if !body.is_star():
			body.hurt()
	if body.has_method("startDying") && shelled : body.startDying()
	else:
		pass
		#queue_free()

func startDying():
	#spawn score popup or 1-up popup
	GameManager.spawn_score_or_1up_popup(global_position)
	queue_free()
