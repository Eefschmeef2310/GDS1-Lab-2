extends Node2D

#Creates the animation where the player stops for half a second before 
#going up and down when dead
func _on_timer_timeout():
	$Sprite2D.queue_free()
	$GPUParticles2D.emitting = true


func _on_gpu_particles_2d_finished():
	print("Particle finished playing")
	print("Restart game with new loading screen")
	#Restart game with new loading screen when the animation finishes playing
