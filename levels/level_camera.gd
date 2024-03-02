extends Camera2D

const SMB_WARNING = preload("res://sounds/smb_warning.wav")

@export var player: CharacterBody2D

var overworld_y: float

@export var fast_pitch : float = 1.5

func _ready():
	overworld_y = global_position.y
	GameManager.updated_subworld.connect(update_camera_y)
	GameManager.music_stoped.connect(stop_music)
	GameManager.hundred_time_left.connect(play_warning)
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

#play warning, then play sped up version
func play_warning():
	if $OverworldTheme.playing:
		$OverworldTheme.stream = SMB_WARNING
		$OverworldTheme.play()
	else:
		$UndergroundTheme.stream = SMB_WARNING
		$UndergroundTheme.play()

func _on_overworld_theme_finished():
	$OverworldTheme.pitch_scale = fast_pitch
	$UndergroundTheme.pitch_scale = fast_pitch
	#AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index($OverworldTheme.bus), 0, true)
	$OverworldTheme.stream = load("res://sounds/Super Mario Bros (NES) Music - Overworld Theme.mp3")
	$OverworldTheme.play()

func _on_underground_theme_finished():
	$OverworldTheme.pitch_scale = fast_pitch
	$UndergroundTheme.pitch_scale = fast_pitch
	#AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index($OverworldTheme.bus), 0, true)
	$UndergroundTheme.stream = load("res://sounds/Super Mario Bros (NES) Music - Underground Theme.mp3")
	$UndergroundTheme.play()
	
func star_music_start():
	$OverworldTheme.stop()
	$UndergroundTheme.stop()
	$StarTheme.play()
	
func star_music_stop():
	$StarTheme.stop()
	$OverworldTheme.play()
