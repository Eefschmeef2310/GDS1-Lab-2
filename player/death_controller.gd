extends Node

const PLAYER_DEATH = preload("res://player/p_death/player_death.tscn")

var alive: bool = true

#Logic for killing the player
#Replaces the player character with another scene 
#Other scene plays the particle system/animation + deals with the new loading screen
func kill_player():
	if(alive):
		GameManager.reduce_lives()
		$"../Music".stop()
		var death_particle = PLAYER_DEATH.instantiate()
		death_particle.global_position = $"..".global_position
		get_tree().root.add_child(death_particle)
		alive = false
		get_parent().queue_free()
	
