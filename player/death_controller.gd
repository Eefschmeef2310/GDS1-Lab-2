extends Node

const PLAYER_DEATH = preload("res://player/p_death/player_death_anim.tscn")
const OOB_DEATH = preload("res://player/p_death/p_death.tscn")

#Called when player is DIRECTLY killed by an enemy
func kill_player():
	var death_particle = PLAYER_DEATH.instantiate()
	#Freeze all enemies on screen
	death_logic(death_particle)
	

#Called when the player falls off the screen
func oob_kill_player():
	var death_particle = OOB_DEATH.instantiate()
	death_logic(death_particle)


#Logic for killing the player
#Replaces the player character with another scene 
#Other scene plays the particle system/animation + deals with the new loading screen	
func death_logic(death_particle):
	GameManager.reduce_lives()
	GameManager.pause_timer()
	death_particle.global_position = $"..".global_position
	get_tree().root.add_child(death_particle)
	get_parent().queue_free()
	
