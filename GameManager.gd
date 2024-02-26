extends Node

var coin_counter = 0
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	#Kill the player
	pass # Replace with function body.
	
func collect_coin():
	coin_counter += 1
	if(coin_counter >= 100):
		#gain 1-up
		#play 1-up sound
		coin_counter = 0
	pass
	
func score_increase(amount):
	score += amount
	pass
