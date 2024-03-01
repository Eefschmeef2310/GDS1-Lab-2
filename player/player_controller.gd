extends CharacterBody2D
class_name PlayerController

const STAR = preload("res://shaders/star.tres")

enum PowerupState {
	SMALL,
	BIG,
	FIRE
}
var powerup_state_names: PackedStringArray = ["small", "big", "fire"]
@export var powerup_state: PowerupState = PowerupState.FIRE
var currently_changing_powerup = false

var fireball_scene: PackedScene = preload("res://player/fireball.tscn")
var fireball_x

var max_star_time: float = 12
var star_timer: float

var max_incinvible_time: float = 3
var invincible_timer: float = 0

# Horizontal movement
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

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Lauren variables
@onready var anim_player = $AnimationPlayer
var is_falling = false
var is_landing = true
#signal toTankControl()

var killY = 9999

func _ready():
	fireball_x = $FireballMarker.position.x

func _process(delta):
	if !currently_changing_powerup:
		#Input
		move_direction = Input.get_axis("left", "right")
		if Input.is_action_just_pressed("jump"):
			jump()
		if Input.is_action_just_released("jump"):
			jump_release()
		
		#Fire
		if powerup_state == PowerupState.FIRE and Input.is_action_just_pressed("run"):
			if velocity.x != 0:
				$AnimationPlayerFire.play("throw_replace")
			else:
				$AnimationPlayerFire.play("throw_whole")
		
		# Timed States
		if invincible_timer > 0:
			invincible_timer -= delta
			$AnimationPlayerInvincible.play("invincible")
		else:
			$AnimationPlayerInvincible.play("base")
		
		if star_timer > 0:
			star_timer -= delta
			# Do visual star stuff here
		
		# Animation
		handle_animations()
		
		if Input.is_action_just_pressed("debug_hurt"):
			hurt()

func _physics_process(delta):
	if !currently_changing_powerup:
		# Handle movement.
		var move_speed = max_speed
		if Input.is_action_pressed("run"):
			move_speed = max_run_speed
		var desired_velocity = move_direction * move_speed * move_factor
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

func move(direction: float):
	move_direction = direction

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

func force_jump():
	coyote_counter = 0
	jump_buffer_counter = 0
	is_jumping = true
	
	# Does not use air jump speed at all right now
	velocity.y = jump_speed * jump_factor

func jump_release():
	jump_is_held = false

func update_direction():
	if move_direction != 0 and is_on_floor():
		$Sprite2D.flip_h = move_direction < 0
		$Sprite2DUpperFire.flip_h = move_direction < 0
		$Sprite2DUpperFireThrow.flip_h = move_direction < 0
		$FireballMarker.position.x = fireball_x * move_direction

#handles all animations
func handle_animations():
	var anim_prefix: String = powerup_state_names[powerup_state] + "_"
	
	#jumping animations
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
	if powerup_state == PowerupState.SMALL:
		powerup_state = PowerupState.BIG
		currently_changing_powerup = true
		$AnimationPlayer.play("big_upgrade")
	elif powerup_state == PowerupState.BIG:
		if new_powerup == "fire":
			powerup_state = PowerupState.FIRE
			currently_changing_powerup = true
			$AnimationPlayer.play("fire_upgrade")
		else:
			# Picked up a mushroom while big.
			pass
	else:
		# Picked up a flower while fire.
		pass

func hurt():
	if powerup_state == PowerupState.SMALL:
		$DeathController.kill_player()
	else:
		powerup_state = PowerupState.SMALL
		currently_changing_powerup = true
		invincible_timer = max_incinvible_time
		$AnimationPlayer.play("small_downgrade")

func toggle_tree(on: bool):
	process_mode = Node.PROCESS_MODE_ALWAYS if on else Node.PROCESS_MODE_INHERIT
	currently_changing_powerup = on
	get_tree().paused = on

func throw_fireball():
	var fireball = fireball_scene.instantiate()
	fireball.global_position = $FireballMarker.global_position
	get_tree().get_root().add_child(fireball)
	if $Sprite2D.flip_h:
		fireball.velocity.x *= -1

func start_star():
	star_timer = max_star_time

# Invincibility after getting hit.
func is_invincible():
	return invincible_timer > 0

# Star powerup that kills things.
func is_star():
	return star_timer > 0

func toggle_shader(on : bool):
	$Sprite2D.material = STAR if on else null
	$Sprite2DUpperFire.material = STAR if on else null
	$Sprite2DUpperFireThrow.material = STAR if on else null
