extends Block
class_name Brick

const BRICK_PARTICLES = preload("res://blocks/brick_particles.tscn")

func _on_player_hit_box_body_entered(body):
	#TODO - tie this to player size to run different functions
	if body != self and body.is_in_group("player"):
		
		#if player is big
		var particles_spawned = BRICK_PARTICLES.instantiate()
		particles_spawned.global_position = global_position
		get_tree().root.add_child(particles_spawned)
		particles_spawned.emitting = true
		queue_free()
		
		#if player is small
		#super.bump()
