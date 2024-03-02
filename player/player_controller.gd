extends CharacterBody2D
class_name PlayerController

enum PowerupState {
	SMALL,
	BIG,
	FIRE
}
var powerup_state_names: PackedStringArray = ["small", "big", "fire"]
@export var powerup_state: PowerupState = PowerupState.FIRE
@export var camera: Camera2D
var currently_changing_powerup = false
var fireball_scene: PackedScene = preload("res://player/fireball.tscn")
var fireball_marker_x: float

var max_incinvible_time: float = 3
@onready var invincibility_timer = $InvincibilityTimer

signal touched_flag(points_value)

# Horizontal movement
var current_max_speed = 85.0
var max_speed = 85.0
var max_run_speed = 150.0
var acceleration = 10.0
var deceleration = 10.0

# Jumping and gravity
var jump_speed = -300.0
var air_jump_speed = -1.0
var rise_factor = 0.6
var fall_factor = 1
var jump_phase = 0
var max_air_jumps = 0;
var jump_requested = false
var jump_is_held = false
var is_jumping = false
var coyote_time = 0.2
var coyote_counter = 0.0
var jump_buffer_time = 0.2
var jump_buffer_counter = 0.0

# Global movement scales
var move_factor = 1
var jump_factor = 1
var gravity_factor = 1

# Input
var move_direction: float
var can_change_direction: bool = true
var is_crouched = false

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Lauren variables
@onready var anim_player = $AnimationPlayer
#var is_falling = false
#var is_landing = true

var player_win_scene = preload("res://player/p_win/mario_win.tscn")

#Star shader and powerup
const STAR = preload("res://shaders/star.tres")
@export var max_star_time: float = 12
@onready var star_timer = $StarTimer

#for stomp sequence
var stomp_sequence : int

func _ready():
	fireball_marker_x = $FireballMarker.position.x

func _process(_delta):
	if is_transitioning():
		return
			
	#reset stomp sequence when on floor. also /looked into it, having a star does NOT stack score
	if is_on_floor():
		stomp_sequence = 0
	
	if !currently_changing_powerup:
		#Input
		move_direction = Input.get_axis("left", "right")
		if powerup_state != PowerupState.SMALL and is_on_floor():
			if move_direction == 0 and Input.is_action_pressed("down"):
				is_crouched = true
			else:
				is_crouched = false
		if Input.is_action_just_pressed("jump"):
			jump()
		if Input.is_action_just_released("jump"):
			jump_release()
		
		
		#Fire
		if powerup_state == PowerupState.FIRE and Input.is_action_just_pressed("run"):
			if velocity.x != 0 and !is_crouched:
				$AnimationPlayerFire.play("throw_replace")
			else:
				$AnimationPlayerFire.play("throw_whole")
		
		# Animation
		handle_animations()
		
		if Input.is_action_just_pressed("debug_hurt"):
			hurt()

func _physics_process(delta):
	if is_transitioning():
		return

	if !currently_changing_powerup:
		# Handle movement.
		if is_on_floor():
			current_max_speed = max_speed
			if Input.is_action_pressed("run"):
				current_max_speed = max_run_speed
		var desired_velocity = move_direction * current_max_speed * move_factor
		if desired_velocity != 0:
			velocity = velocity.move_toward(Vector2(desired_velocity, velocity.y), acceleration)
		else:
			velocity = velocity.move_toward(Vector2(0, velocity.y), deceleration)
			
		# Flip based on movement input.
		if can_change_direction:
			update_direction()
			
		# Handle jumping.
		if is_on_floor():
			jump_phase = 0
			coyote_counter = coyote_time
			is_jumping = false
		else:
			coyote_counter -= delta
		
		if jump_buffer_counter > 0:
			jump_buffer_counter -= delta
			try_jump()
			
		# Add the gravity.
		if jump_is_held and velocity.y < 0:
			velocity.y += gravity * delta * rise_factor
		elif !jump_is_held or velocity.y > 0:
			velocity.y += gravity * delta * fall_factor
		elif velocity.y == 0:
			velocity.y  += gravity * delta
		
		# Move and slide.
		move_and_slide()

#func move(direction: float):
	#move_direction = direction

func jump():
	jump_is_held = true
	jump_buffer_counter = jump_buffer_time
	
func try_jump():
	if coyote_counter > 0:
		if is_jumping:
			jump_phase += 1
			
		coyote_counter = 0
		jump_buffer_counter = 0
		is_jumping = true
		
		# Does not use air jump speed at all right now
		velocity.y = jump_speed * jump_factor
		
		if powerup_state == PowerupState.SMALL:
			$small_jump.play()
		else:
			$big_jump.play()

#func force_jump():
	#coyote_counter = 0
	#jump_buffer_counter = 0
	#is_jumping = true
	#
	## Does not use air jump speed at all right now
	#velocity.y = jump_speed * jump_factor

func jump_release():
	jump_is_held = false

func update_direction():
	if move_direction != 0 and is_on_floor():
		$Sprite2D.flip_h = move_direction < 0
		$Sprite2DUpperFire.flip_h = move_direction < 0
		$Sprite2DUpperFireThrow.flip_h = move_direction < 0
		$FireballMarker.position.x = fireball_marker_x * move_direction

#handles all animations
func handle_animations():
	var anim_prefix: String = powerup_state_names[powerup_state] + "_"
	
	if is_crouched:
		anim_player.play(anim_prefix + "crouch")
	else:
		if not is_on_floor():
			anim_player.play(anim_prefix + "jump")
		else:
			if velocity.x != 0:
				if move_direction != 0 and move_direction != sign(velocity.x):
					anim_player.play(anim_prefix + "skid")
				elif abs(velocity.x) >= max_run_speed:
					anim_player.play(anim_prefix + "run_fast")
				else:
					anim_player.play(anim_prefix + "run")
			else:
				anim_player.play(anim_prefix + "idle")

func get_death_controller():
	return $DeathController

func change_powerup(new_powerup: String):
	$powerup.play()
	if powerup_state == PowerupState.SMALL:
		powerup_state = PowerupState.BIG
		currently_changing_powerup = true
		$AnimationPlayer.play("big_upgrade")
	elif powerup_state == PowerupState.BIG or powerup_state == PowerupState.SMALL:
		if new_powerup == "fire":
			powerup_state = PowerupState.FIRE
			currently_changing_powerup = true
			$AnimationPlayer.play("fire_upgrade")
		else:
			# Picked up a mushroom while big.
			pass

func _on_flag_collision_area_entered(area):
	var pos = global_position
	var area_type = area.get_groups()
	if (area_type.has("flag")):
		
		var player_win = player_win_scene.instantiate()
		$"..".call_deferred("add_child", player_win)
		player_win.global_position = pos
		player_win.powerup_state = powerup_state
		if (area_type.has("5000p")):
			print("5000 points")
			touched_flag.emit(5000)
		elif (area_type.has("2000p")):
			print("2000 points")
			touched_flag.emit(2000)
		elif (area_type.has("800p")):
			print("800 points")
			touched_flag.emit(800)
		elif (area_type.has("400p")):
			print("400 points")
			touched_flag.emit(400)
		elif (area_type.has("100p")):
			print("100 points")
			touched_flag.emit(100)
		#print(position)
		#print(player_win.position)
		GameManager.stop_playing_music()
		queue_free();

func hurt():
	$powerdown.play()
	if powerup_state == PowerupState.SMALL:
		$DeathController.kill_player()
	else:
		powerup_state = PowerupState.SMALL
		currently_changing_powerup = true
		invincibility_timer.start(max_incinvible_time)
		$AnimationPlayer.play("small_downgrade")
		$AnimationPlayerInvincible.play("invincible")
		
func _on_invincibility_timer_timeout():
	$AnimationPlayerInvincible.play("base")

func toggle_tree(on: bool):
	process_mode = Node.PROCESS_MODE_ALWAYS if on else Node.PROCESS_MODE_INHERIT
	currently_changing_powerup = on
	if (camera != null):
		camera.process_mode = Node.PROCESS_MODE_ALWAYS if on else Node.PROCESS_MODE_INHERIT
	get_tree().paused = on

func throw_fireball():
	$fireball.play()
	var fireball = fireball_scene.instantiate()
	fireball.global_position = $FireballMarker.global_position
	get_tree().root.add_child(fireball)
	if $Sprite2D.flip_h:
		fireball.velocity.x *= -1

#Refactored the pipe code into Transition Contoller
func anim_teleport(tele_location, down: bool):
	velocity = Vector2(0, 0)
	$TransitionController.pipe_in_animation(down, tele_location)

#Checks if mario is in pipe (to prevent any input/animations being called when true)
func is_transitioning():
	return $TransitionController.is_transitioning()
	

func start_star():
	GameManager.star_music()
	toggle_shader(true)
	star_timer.start(max_star_time)
	
func _on_star_timer_timeout():
	GameManager.star_music_stop()
	toggle_shader(false)

# Invincibility after getting hit.
func is_invincible():
	return invincibility_timer.time_left > 0

func is_star():
	return star_timer.time_left > 0

func toggle_shader(on : bool):
	#Set shader on ALL Sprites
	$Sprite2D.material = STAR if on else null
	$Sprite2DUpperFire.material = STAR if on else null
	$Sprite2DUpperFireThrow.material = STAR if on else null
