extends CanvasLayer

@onready var score = $MarginContainer/HBoxContainer/Score
@onready var coins = $MarginContainer/HBoxContainer/Coins
@onready var time = $MarginContainer/HBoxContainer/Time

var underground : bool = false
var loading_screen : bool = false

var coin_animation : AnimatedTexture

func _ready():
	GameManager.score_updated.connect(update_score)
	GameManager.coins_updated.connect(update_coin)
	
func _process(_delta):
	time.text = "TIME\n" + str(int(GameManager.timer.time_left * 2.5)) if !loading_screen else "TIME\n\n"

func update_score():
	score.text = "MARIO\n" + str(GameManager.score).pad_zeros(6)

func update_coin():
	if !underground:
		coin_animation = preload("res://ui/coin.tres")
	else:
		coin_animation = preload("res://ui/underground_coin.tres")
	coins.text = "\n[center][img]" + coin_animation.resource_path + "[/img][img]res://ui/sprites/x.png[/img]" + str(GameManager.coin_counter).pad_zeros(2)
