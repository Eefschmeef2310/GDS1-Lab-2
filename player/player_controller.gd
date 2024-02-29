extends CharacterBody2D
class_name PlayerController

enum PowerupState {
	SMALL,
	BIG,
	FIRE
}
var powerup_state_names: PackedStringArray = ["small", "big", "fire"]
@export var powerup_state: PowerupState = PowerupState.FIRE

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
	pass

func _process(_delta):
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
	
	handle_animations()

func _physics_process(delta):
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
