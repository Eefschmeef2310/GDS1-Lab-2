extends CharacterBody2D

@export var is_exploding = false

func _ready():
	velocity.x = 200
	velocity.y = 150
	$AnimationPlayer.play("idle")

func _physics_process(_delta):
	if !is_exploding:
		if is_on_floor():
			velocity.y = -150
		velocity.y += 15
		velocity.y = clamp(velocity.y, -150, 150)
		
		if is_on_wall():
			$AnimationPlayer.play("explode")
			
		move_and_slide()
