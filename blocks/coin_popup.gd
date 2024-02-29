extends Sprite2D

@export var score : int = 200

const SCORE_POPUP = preload("res://ui/score_popup.tscn")

func _ready():
	GameManager.increase_score(score)
	GameManager.collect_coin()

func spawn_popup():
	var score_popup = SCORE_POPUP.instantiate()
	score_popup.set_values(score, global_position)
	get_tree().root.add_child(score_popup)

func bump():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(0, -60), 0.35)
	tween.chain().tween_property(self, "position", position, 0.35)
