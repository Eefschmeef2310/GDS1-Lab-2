extends CharacterBody2D
class_name Ground_Enemy

@export var speed : float = 30
@export var deadTime : float = 0.5 #used to control how long to show the dead state before being deleted 
var dying : bool = false
var direction : int = -1 #start moving towards the player




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

