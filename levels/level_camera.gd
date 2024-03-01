extends Camera2D

@export var player: CharacterBody2D

var in_subworld: bool = false

func _ready():
	GameManager.player_teleported_subworld.connect(camera_to_subworld)
	pass

func _physics_process(_delta):
	if(player != null && !in_subworld):
		global_position.x = max(global_position.x, player.global_position.x)
		
func camera_to_subworld():
	global_position.y = 360
	global_position.x = 2496
	in_subworld = true
	pass
	

