extends Node2D

@onready var anim_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("RESET")

func _on_flag_collision_controller_touched_flag():
	anim_player.play("flag")
