extends CanvasLayer

@onready var score = $MarginContainer/HBoxContainer/Score
@onready var coins = $MarginContainer/HBoxContainer/Coins
@onready var time = $MarginContainer/HBoxContainer/Time

func _ready():
	GameManager.score_updated.connect(update_score)
	GameManager.coins_updated.connect(updates_coin)
	
func _process(_delta):
	time.text = "TIME\n" + str(int(GameManager.timer.time_left * 2.5))

func update_score():
	score.text = "MARIO\n" + str(GameManager.score).pad_zeros(6)

func updates_coin():
	coins.text = "\n[center][img]res://ui/coin.tres[/img][img]res://ui/sprites/x.png[/img]" + str(GameManager.coin_counter).pad_zeros(2)
