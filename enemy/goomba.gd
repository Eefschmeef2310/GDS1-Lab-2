extends CharacterBody2D


@export var speed : float = 30
@export var deadTime : float = 0.5 #used to control how long to show the dead state before being deleted 
var dying : bool = false
var direction : int = -1 #start moving towards the player

@export var animated_sprite_2d : AnimatedSprite2D
@export var collision_shape_2d : CollisionShape2D



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	if(dying):
		deadTime -= delta
	if deadTime < 0:
		queue_free()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if dying:
		velocity.y = 0
	
	if !dying:
		velocity.x = direction * speed


	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		dying = true
		animated_sprite_2d.set_animation("dead")
		collision_shape_2d.set_deferred("disabled",true)
		body.velocity.y += -300


func _on_direction_hitbox_body_entered(body):
	if !body.is_in_group("player"):
		scale.x *= -1
		direction *= -1
