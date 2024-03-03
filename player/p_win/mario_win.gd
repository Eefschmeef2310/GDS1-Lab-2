extends CharacterBody2D

@export var climb_speed = 50
var y_velocity = 0
var x_velocity = 0

@onready var anim_player = $AnimationPlayer
var state = "sliding"

var powerup_state_names: PackedStringArray = ["small", "big", "fire"]
@export var powerup_state: PlayerController.PowerupState
var currently_changing_powerup = false

func _ready():
	anim_player.play("RESET")
	$FlagSlideFX.playing = true

func _physics_process(delta):

	## Add the gravity.
	
	if position.y < 192:
		y_velocity = climb_speed * delta
		position.y += y_velocity
		
		match powerup_state:
			PlayerController.PowerupState.SMALL:
				anim_player.play("flag_slide_small")
			PlayerController.PowerupState.BIG:
				anim_player.play("flag_slide_big")
			PlayerController.PowerupState.FIRE:
				anim_player.play("flag_slide_big_fire")
	
		#if (powerup_state == PowerupState.SMALL):
			#anim_player.play("flag_slide_small")
		#elif (powerup_state == PowerupState.BIG):
			#anim_player.play("flag_slide_big")
		#elif (powerup_state == PowerupState.FIRE):
			#anim_player.play("flag_slide_big_fire")
	
	elif(position.y >= 192):
		if state != "run":
			state = "run"
			$FlagSlideFX.playing = false
			$WinMusic.playing = true
			position.y = 192
			
			match powerup_state:
				PlayerController.PowerupState.SMALL:
					anim_player.play("jump_off_flag_small")
				PlayerController.PowerupState.BIG:
					anim_player.play("jump_off_flag_big")
				PlayerController.PowerupState.FIRE:
					anim_player.play("jump_off_flag_big_fire")
					
			#if (powerup_state == PlayerController.PowerupState.SMALL):
				#$AnimationPlayer.play("jump_off_flag_small")
			#elif (powerup_state == PowerupState.BIG):
				#$AnimationPlayer.play("jump_off_flag_big")
			#elif (powerup_state == PowerupState.FIRE):
				#$AnimationPlayer.play("jump_off_flag_big_fire")
		
			
		
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	#move_and_slide()

func start_bonus_time():
	GameManager.level_complete = true
	GameManager.add_bonus_time()

func _on_win_music_finished():
	get_tree().change_scene_to_file("res://levels/you_win.tscn")
