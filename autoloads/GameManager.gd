extends Node

signal score_updated
signal coins_updated

@onready var timer = $Timer

#Because we know these variables will only be ints, we can cast them as such
var coin_counter : int = 0
var score : int = 0
var lives : int = 3

func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()

#You don't need to have pass in a method if ther are other lines of code
func _on_timer_timeout():
	#Kill the player
	pass
	
func collect_coin():
	coin_counter += 1
	if(coin_counter >= 100):
		gain_1up()
		#play 1-up sound
		coin_counter = 0
	coins_updated.emit()
	
func increase_score(amount):
	score += amount
	score_updated.emit()
	#logic here for stacking score? we'll see how xander sorts out the character controller
	
func gain_1up():
	lives += 1
	
func reduce_lives():
	lives -= 0
	if(lives == 0):
		#game over
		pass
