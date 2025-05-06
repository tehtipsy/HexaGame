extends AnimatedSprite2D


@export var animation_to_play_on_time_change := "default"
@export var default_animation_duration: float = 0.8 # in seconds

var animation_timer: Timer


func _ready():
	if GameState:
		GameState.time_changed.connect(_on_GameState_time_changed)
	else:
		printerr("GameState singleton not found.")

	animation_timer = Timer.new()
	animation_timer.one_shot = true
	animation_timer.timeout.connect(_on_animation_timer_timeout)
	add_child(animation_timer)

func _on_GameState_time_changed(new_time: int, time_increment: int):
	var current_play_duration: float

	if time_increment > 0:
		current_play_duration = float(time_increment)
	else:
		current_play_duration = default_animation_duration

	animation_timer.wait_time = current_play_duration

	if not animation_to_play_on_time_change.is_empty() and sprite_frames.has_animation(animation_to_play_on_time_change):
		play(animation_to_play_on_time_change)
	elif sprite_frames.has_animation("default"):
		play("default")
	else:
		play()

	animation_timer.start()
	print("Time changed to: ", new_time, ". Playing animation for ", current_play_duration, " seconds.")


func _on_animation_timer_timeout():
	stop()
	print("Animation finished after ", animation_timer.wait_time, " seconds.")
