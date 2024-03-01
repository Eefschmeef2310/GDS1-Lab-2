extends CharacterBody2D

@export var climb_speed = 50
var y_velocity = 0
var x_velocity = 0

@onready var anim_player = $AnimationPlayer
var state = "sliding"


enum PowerupState {
	SMALL,
	BIG,
	FIRE
}
var powerup_state_names: PackedStringArray = ["small", "big", "fire"]
@export var powerup_state: PowerupState
var currently_changing_powerup = false

func _ready():
	anim_player.play("RESET")
	$FlagSlideFX.playing = true
	print("pleaes" + str(powerup_state))


func _physics_process(delta):

	## Add the gravity.
	
	if position.y < 192:
		y_velocity = climb_speed * delta
		position.y += y_velocity
	
		if (powerup_state == PowerupState.SMALL):
			anim_player.play("flag_slide_small")
		elif (powerup_state == PowerupState.BIG):
			anim_player.play("flag_slide_big")
		elif (powerup_state == PowerupState.FIRE):
			anim_player.play("flag_slide_big_fire")
	
	elif(position.y >= 192):
		if state != "run":
			state = "run"
			$FlagSlideFX.playing = false
			$WinMusic.playing = true
			position.y = 192
			if (powerup_state == PowerupState.SMALL):
				$AnimationPlayer.play("jump_off_flag_small")
			elif (powerup_state == PowerupState.BIG):
				$AnimationPlayer.play("jump_off_flag_big")
			elif (powerup_state == PowerupState.FIRE):
				$AnimationPlayer.play("jump_off_flag_big_fire")
		
			
		
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
