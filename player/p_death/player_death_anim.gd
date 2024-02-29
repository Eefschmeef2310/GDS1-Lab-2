extends Node2D

#Creates the animation where the player stops for half a second before 
#going up and down when dead
func _on_timer_timeout():
	$Sprite2D.queue_free()
	$GPUParticles2D.emitting = true
