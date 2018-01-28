extends Control

var Game = preload("res://scenes/Game.tscn").instance()
onready var popup = get_node("Out/AboutMenu")

func create_random_game():
	Game.gamemode = 0
	Game.set_dispensers_gamemode(0)
	start_game(Game)

func create_game_from_file(level_number):
	Game = preload("res://scenes/Game.tscn").instance()
	Game.gamemode = level_number
	Game.set_dispensers_gamemode(level_number)
	
	var level = Game.extract_level(level_number)
	Game.level_array = interpret_file(level)
	Game.load_dispensers()
	start_game(Game)
	Game.load_goal()
	
	# Unlock level
	get_node("Out/AboutMenu/VBox/LevelGrid").get_child(level_number - 1).disabled = false

func start_game(Game):  # Add game node as a sister of the Main menu
	var parent = get_parent()
	parent.add_child(Game)
	hide()

func interpret_file(level):  # Transform file contents in arrays
	var level_array = []
	var arr = []
	var goal = []
	var word = ""
	for character in level:
		var number_of_columns = 4
		if arr.size() == number_of_columns:
			level_array.append(arr)
			arr = []
		if character.is_valid_integer() || character == ".":
			word += character
		elif character == "\n" || character == "" || character == " ":
			if !word.empty():
				arr.append(word)
			word = ""
	level_array.append(arr)
	print(level_array) # DEBUG
	return level_array

func save_game():  # Serialize Menu node
	var savegame = File.new()
	savegame.open("user://savefile.sv", File.WRITE)
	var save_dict = {
		# TODO
	}

func show_up():
	var player = preload("res://scenes/Player.tscn").instance()
	player.position = Vector2(149, 537)
	player.scale = Vector2(4.7, 4.7)
	$Out/Fluff.add_child(player)
	show()

# --- Menu Buttons ---

func _on_Start_pressed():
	popup.visible = true
	popup.rect_position = Vector2(53, 37)
	popup.rect_size = Vector2(189, 375)

func _on_About_pressed():
	pass

func _on_Level1_pressed():
	create_game_from_file(1)
	button_pressed()

func _on_Level2_pressed():
	create_game_from_file(2)
	button_pressed()

func _on_Level3_pressed():
	create_game_from_file(3)
	button_pressed()

func _on_Level4_pressed():
	create_game_from_file(4)
	button_pressed()

func _on_Random_pressed():
	create_random_game()
	Game.load_random_goal()
	button_pressed()

func button_pressed():  # Function to be called after a relevant bt press
	popup.hide()
	get_node("Out/Fluff/Player").queue_free()

# --- Social media buttons ---

func _on_Twitter_pressed():
	OS.shell_open("https://twitter.com/a_barichello")

func _on_GitHub_pressed():
	OS.shell_open("https://github.com/abarichello/bat-hit-ball")

func _on_Telegram_pressed():
	OS.shell_open("https://t.me/abarichello")
