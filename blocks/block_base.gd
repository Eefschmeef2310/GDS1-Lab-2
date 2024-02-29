extends StaticBody2D
class_name Block

@export var bump_speed : float = 0.12
@export var bump_height : int = 5

#make the block bump upwards
func bump():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(0, -bump_height), bump_speed)
	tween.chain().tween_property(self, "position", position, bump_speed)
	
	$Bump.play()
