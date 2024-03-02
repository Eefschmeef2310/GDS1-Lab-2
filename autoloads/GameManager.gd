extends Node

const SCORE_POPUP = preload("res://ui/score_popup.tscn")
const _1_UP_POPUP = preload("res://ui/1up_popup.tscn")

signal score_updated
signal coins_updated
signal updated_subworld
signal music_stoped
signal hundred_time_left
signal star_music_start
signal star_music_stopped


var fast_time : bool = false
@onready var timer = $Timer
@onready var audio_stream_player = $AudioStreamPlayer

#Because we know these variables will only be ints, we can cast them as such
var coin_counter : int = 0
var score : int = 0
var lives : int = 3

var level1_checkpoint : bool
var in_subworld: bool = false

var player_scores : Array[int] = [
	100,
	200,
	400,
	500,
	800,
	1000,
	2000,
	4000,
	5000,
	8000] #all score stacking. anything above is a 1-UP
var shell_scores : Array[int] = [
	500,
	800,
	1000,
	2000,
	4000,
	5000,
	8000]

func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
	if int(timer.time_left * 2.5) == 100 and !fast_time:
		fast_time = true
		hundred_time_left.emit()

func _on_timer_timeout():
	get_tree().get_first_node_in_group("player").hurt()

func reset():
	fast_time = false
	coin_counter = 0
	score = 0
	lives = 3
	level1_checkpoint = false
	score_updated.emit()
	
func collect_coin():
	coin_counter += 1
	$CoinSFX.play()
	if(coin_counter >= 100):
		gain_1up()
		#play 1-up sound
		coin_counter = 0
	coins_updated.emit()
	
func increase_score(amount):
	score += amount
	score_updated.emit()
	
func gain_1up():
	audio_stream_player.play()
	lives += 1
	
func reduce_lives():
	lives -= 1

#Should be called after the player dies
func restart_level():
	#Restart game from loading screen (due to autoload, it should save the stats)
	get_tree().change_scene_to_file("res://levels/loading_screen.tscn")
	
func get_subworld_state():
	return in_subworld
	
func update_subworld():
	in_subworld = !in_subworld
	UI.underground = in_subworld
	UI.update_coin()
	#Updates the level camera to change position
	updated_subworld.emit()

func spawn_score_or_1up_popup(position : Vector2):
	#Method for calculating chained attacks
	if get_tree().get_first_node_in_group("player").stomp_sequence < player_scores.size():
		#spawn score popup
		var score_popup = SCORE_POPUP.instantiate()
		score_popup.set_values(player_scores[get_tree().get_first_node_in_group("player").stomp_sequence], position)
		get_tree().root.add_child(score_popup)
	else:
		get_tree().root.add_child(_1_UP_POPUP.instantiate())
		

func stop_playing_music():
	music_stoped.emit()

func star_music():
	star_music_start.emit()

func star_music_stop():
	star_music_stopped.emit()
