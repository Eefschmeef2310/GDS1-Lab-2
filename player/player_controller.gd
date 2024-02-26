extends CharacterBody2D
class_name PlayerController

# Horizontal movement
var max_speed = 200.0
var acceleration = 300.0
var deceleration = 300.0

# Jumping and gravity
var jump_speed = -400.0
var air_jump_speed = -400.0
var rise_factor = 1
var fall_factor = 2
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
#@onready var sprite_animator = $SpriteAnimator
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
	
	#handle_animations()

func _physics_process(delta):
	# Handle movement.
	var desired_velocity = move_direction * max_speed * move_factor
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
	if coyote_counter > 0 or (jump_phase < max_air_jumps and is_jumping):
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
	pass
	#if move_direction != 0:
		#$AnimatedSprite2D.flip_h = move_direction < 0

##handles all animations
#func handle_animations():
	##jumping animations
	#
	#if not is_on_floor():
		#if (velocity.y < 0):
			#sprite_animator.play("Jump")
		#elif (velocity.y > 0):
			#sprite_animator.play("Falling")
			#is_falling = true
		#else:
			#sprite_animator.play("midair")
	#else:
		#if (is_falling == true):
			#is_falling = false
			#is_landing = true
			#sprite_animator.play("Land")
		#else:
			#if move_direction != 0:
					#sprite_animator.play("Run")
					#is_landing = false
			#elif not (is_landing):
				#sprite_animator.play("Idle")
#
#func _on_animated_sprite_2d_animation_finished():
	#if (is_landing == true):
		#is_landing = false
