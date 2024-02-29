extends Node

const PLAYER_DEATH = preload("res://player/p_death/player_death.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func kill_player():
	var death_particle = PLAYER_DEATH.instantiate()
	death_particle.global_position = get_parent().global_position
	get_parent().queue_free()
