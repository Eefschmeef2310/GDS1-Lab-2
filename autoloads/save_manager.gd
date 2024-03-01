extends Node

var save_game : SaveDataRes
var save_path : String = "user://savegame.tres"
			
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	if FileAccess.file_exists(save_path):
		load_save()
	else:
		save_game = SaveDataRes.new()
	
func save():
	ResourceSaver.save(save_game, save_path)
	
func load_save():
	save_game = ResourceLoader.load(save_path)

func update_score(amount):
	if save_game.high_score < amount:
			save_game.high_score = amount
			save()
