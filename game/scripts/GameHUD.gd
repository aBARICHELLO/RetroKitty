extends Control

signal game_over
signal round_ended

onready var player = get_node("/root/Main/Game/Player")
var correct_array = []
var balls_hit = 0
var screensize
var goal_number

func _ready(goal_array):
	$PauseMenu.hide()
	screensize = get_node("/root").get_viewport().get_visible_rect().size
	self.goal_number = goal_array.size()
	
	print("goal:")
	print(goal_array)
	
	for i in range(0, goal_number):
		var ball = preload("res://scenes/Ball.tscn").instance()
		randomize()
		var color = goal_array[i]
		ball._ready(color, 0)
		# Containers
		var center_container = CenterContainer.new()
		center_container.add_child(ball)
		$UpperLeftPanel/VBox/HBox/HSplit.add_child(center_container)
		correct_array.append(ball)
	# Centering
	$UpperLeftPanel.rect_global_position.x = screensize.x / 2 - $UpperLeftPanel.get_rect().size.x / 2

func _process(delta):
	var _player = get_node("/root/Main/Game/Player")
	$UpperLeftPanel/VBox/ProgressBar.value = _player.hp
	if balls_hit == correct_array.size():
		emit_signal("round_ended")

func _input(event):
	if event.is_action_pressed("ui_escape"):
		$PauseMenu.show()
		get_tree().set_pause(true)

func hit_check(ball):
	# 8 = WHITE, 9 = BLACK
	if balls_hit < correct_array.size() && ball.color == correct_array[balls_hit].color:
		$UpperLeftPanel/VBox/HBox/HSplit.get_child(balls_hit).modulate = Color(0, 0, 0, 50)
		balls_hit += 1
		$GracePeriod.start()
	elif balls_hit < correct_array.size() && ball.color != correct_array[balls_hit].color && ball.color != 8:
		if $GracePeriod.time_left == 0:
			player.hp -= 1

func out_check(ball):
	var valid = balls_hit < correct_array.size()
	if valid && (ball.color == correct_array[balls_hit].color || ball.color == 8):
		player.hp -= 1

func _on_GameHUD_game_over():  # Restart level when all dispensers empty and no goal met
	var _player = get_node("/root/Main/Game/Player")
	_player.game_over()

func _on_GameHUD_round_ended():  # On Screen stuff for next round
	print("--ROUND OVER--")
	var _player = get_node("/root/Main/Game/Player")
	_player.round_ended()
	$Intermission.start()

func _on_Intermission_timeout():  # Change to next level
	var Game = get_node("/root/Main/Game")
	Game.set_dispensers_gamemode(0)  # Dispenser deactivated mode
	var Main = get_node("/root/Main")
	Main.delete_game()
	Main.start_loading_timer()

# --- Buttons ---

func _on_Resume_pressed():
	$PauseMenu.hide()
	get_tree().set_pause(false)

func _on_Quit_pressed():
	var Main = get_node("/root/Main")
	Main.delete_game()
	get_tree().set_pause(false)
	get_node("/root/Main/Menu").show_up()
