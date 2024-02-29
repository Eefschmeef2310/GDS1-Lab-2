extends Area2D

func _on_area_entered(area):
	var area_type = area.get_groups()
	if (area_type.has("flag")):
		if (area_type.has("5000p")):
			print("5000 points")
		elif (area_type.has("2000p")):
			print("2000 points")
		elif (area_type.has("800p")):
			print("800 points")
		elif (area_type.has("400p")):
			print("400 points")
		elif (area_type.has("100p")):
			print("100 points")

