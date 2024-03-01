extends Camera2D

@export var player: CharacterBody2D

var in_subworld: bool = false
var overworld_y: float

func _ready():
	overworld_y = global_position.y
	GameManager.updated_subworld.connect(update_camera_y)
	pass

func _physics_process(_delta):
	if(player != null && !in_subworld):
		global_position.x = max(global_position.x, player.global_position.x)
		

func update_camera_y():
	if(GameManager.get_subworld_state()):
		camera_to_subworld()
	else:
		camera_to_overworld()

func camera_to_overworld():
	global_position.y = overworld_y
	in_subworld = false

func camera_to_subworld():
	global_position.y = 360
	global_position.x = 2496
	in_subworld = true
	

