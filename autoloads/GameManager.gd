extends Node

signal score_updated
signal coins_updated
signal updated_subworld

@onready var timer = $Timer
@onready var audio_stream_player = $AudioStreamPlayer

#Because we know these variables will only be ints, we can cast them as such
var coin_counter : int = 0
var score : int = 0
var lives : int = 3

var level1_checkpoint : bool
var in_subworld: bool = false

func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()

#You don't need to have pass in a method if ther are other lines of code
func _on_timer_timeout():
	#Kill the player
	pass

func reset():
	coin_counter = 0
	score = 0
	lives = 3
	level1_checkpoint = false
	
func collect_coin():
	coin_counter += 1
	if(coin_counter >= 100):
		gain_1up()
		#play 1-up sound
		coin_counter = 0
	coins_updated.emit()
	increase_score(200)
	
func increase_score(amount):
	score += amount
	score_updated.emit()
	#logic here for stacking score? we'll see how xander sorts out the character controller
	
func gain_1up():
	audio_stream_player.play()
	lives += 1
	
func reduce_lives():
	lives -= 1
	if(lives == 0):
		get_tree().change_scene_to_file("res://levels/game_over.tscn")

#Should be called after the player dies
func restart_level():
	#Restart game from loading screen (due to autoload, it should save the stats)
	get_tree().change_scene_to_file("res://levels/loading_screen.tscn")
	
func get_subworld_state():
	return in_subworld
	
func update_subworld():
	in_subworld = true if !in_subworld else false
	#Updates the level camera to change position
	updated_subworld.emit()
