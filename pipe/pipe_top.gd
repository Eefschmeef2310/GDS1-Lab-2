extends StaticBody2D

enum PipeDirection{
	UP,
	LEFT
}

signal transported_to_subworld

@export var pipe_direction: PipeDirection = PipeDirection.UP
var can_transport: bool = false
@export var tele_location: Vector2
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if(player == null):
		return
	
	#I hate coding sometimes jesus christ wtf did I just write
	if(can_transport == true && player.is_on_floor()):
		if(Input.is_action_just_pressed("down") && pipe_direction == PipeDirection.UP):
			player.anim_teleport(tele_location, true)
			can_transport = false
		elif(Input.is_action_just_pressed("right") && pipe_direction == PipeDirection.LEFT):
			player.anim_teleport(tele_location, false)
			can_transport = false


func _on_tele_collider_body_entered(body):
	if(body.is_in_group("player")):
		player = body
		can_transport = true

func _on_tele_collider_body_exited(body):
	if(body.is_in_group("player")):
		can_transport = false