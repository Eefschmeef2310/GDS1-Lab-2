extends Node

enum TDirection{
	UP,
	DOWN,
	RIGHT
}
const PIPE_SPEED: float = 40
@onready var player : PlayerController = $".."
var t_direction: TDirection
var transitioning: bool = false
var going_out: bool = false
var tele_position

func _process(delta):
	if(transitioning):
		if(t_direction == TDirection.DOWN):
			player.global_position.y += delta*PIPE_SPEED
		elif(t_direction == TDirection.RIGHT):
			player.global_position.x += delta*PIPE_SPEED
		else:
			#Only called when the player is going back into the overworld
			player.global_position.y -= delta*PIPE_SPEED
			if(player.global_position.y <= tele_position.y):
				transitioning = false
	
	
func pipe_in_animation(down: bool, tele_pos: Vector2):
	t_direction = TDirection.DOWN if down else TDirection.RIGHT
	transitioning = true
	tele_position = tele_pos
	$"../PipeAnimTimer".start()
	$"../powerdown".play()
	
func pipe_out_animation():
	transitioning = true
	t_direction = TDirection.UP
	player.global_position.y += PIPE_SPEED

func is_transitioning():
	return transitioning

func _on_pipe_anim_timer_timeout():
	transitioning = false
	GameManager.update_subworld()
	player.global_position = tele_position
	if(!GameManager.get_subworld_state()):
		player.handle_animations()
		pipe_out_animation()
