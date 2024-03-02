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




func _on_enemy_hit_box_area_entered(area : Area2D):
	#print(area.get_parent().get_groups())
	if area.get_parent().is_in_group("entity"):
		$AnimationPlayer.play("explode")
		if area.get_parent().has_method("startDying") : area.get_parent().startDying()
		else: area.get_parent().queue_free()
