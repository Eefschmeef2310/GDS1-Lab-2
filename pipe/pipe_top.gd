extends StaticBody2D

enum PipeDirection{
	UP,
	LEFT
}

signal transported_to_subworld

@export var pipe_direction: PipeDirection = PipeDirection.UP
var can_transport: bool = false
var on_edge: bool = false
@export var tele_location: Vector2
var player


	
func _physics_process(_delta):
	if(player == null):
		return
	
	if(can_transport == true && player.is_on_floor() && !on_edge):
		if(Input.is_action_pressed("down") && pipe_direction == PipeDirection.UP):
			player.anim_teleport(tele_location, true)
			can_transport = false
		elif(Input.is_action_pressed("right") && pipe_direction == PipeDirection.LEFT):
			player.anim_teleport(tele_location, false)
			can_transport = false


func _on_tele_collider_body_entered(body):
	if(body.is_in_group("player")):
		player = body
		can_transport = true

func _on_tele_collider_body_exited(body):
	if(body.is_in_group("player")):
		can_transport = false


func _on_edge_detector_body_entered(body):
	if(body.is_in_group("player")):
		on_edge = true

func _on_edge_detector_body_exited(body):
	if(body.is_in_group("player")):
		on_edge = false
