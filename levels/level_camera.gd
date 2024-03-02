extends Camera2D

@export var player: CharacterBody2D

var overworld_y: float

func _ready():
	overworld_y = global_position.y
	GameManager.updated_subworld.connect(update_camera_y)
	GameManager.music_stoped.connect(stop_music)
	GameManager.star_music_start.connect(star_music_start)
	GameManager.star_music_stopped.connect(star_music_stop)


func _physics_process(_delta):
	if(player != null && !GameManager.get_subworld_state()):
		global_position.x = max(global_position.x, player.global_position.x)
		

func update_camera_y():
	if(GameManager.get_subworld_state()):
		#Positions the camera perfectly for subworld
		$OverworldTheme.stop()
		$UndergroundTheme.play()
		global_position.y = 360
		global_position.x = 2496
	else:
		global_position.y = overworld_y
		$OverworldTheme.play()
		$UndergroundTheme.stop()
		
func stop_music():
	$OverworldTheme.stop()
	$UndergroundTheme.stop()
	
func star_music_start():
	$OverworldTheme.stop()
	$UndergroundTheme.stop()
	$StarTheme.play()
	
func star_music_stop():
	$StarTheme.stop()
	$OverworldTheme.play()
