extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play_backwards("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	handle_pause()


func resume_game():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("pause_menu")
	%PauseMenu.hide()


func pause_game():
	get_tree().paused = true
	%PauseMenu.show()
	$AnimationPlayer.play("pause_menu")


func handle_pause():
	if Input.is_action_just_pressed('ui_cancel') and !get_tree().paused:
		pause_game()
	elif Input.is_action_just_pressed('ui_cancel') and get_tree().paused:
		resume_game()


func _on_resume_game_button_pressed():
	resume_game()


func _on_options_menu_button_pressed():
	pass # Replace with function body.


func _on_save_game_button_pressed():
	pass # Replace with function body.


func _on_restart_game_button_pressed():
	resume_game()
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed():
	resume_game()
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
