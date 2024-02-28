extends Block

const BRICK_PARTICLES = preload("res://blocks/brick_particles.tscn")

func _on_player_hit_box_body_entered(body):
	#TODO - tie this to player size to run different functions
	if body != self and body.is_in_group("player"):
		
		if body.powerup_state != PlayerController.PowerupState.SMALL:
			var particles_spawned = BRICK_PARTICLES.instantiate()
			particles_spawned.global_position = global_position
			get_tree().root.add_child(particles_spawned)
			particles_spawned.emitting = true
			queue_free()
		else:
			super.bump()
