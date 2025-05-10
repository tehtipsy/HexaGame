class_name Character extends Control


@export var total_calories: int = 0


func _process(delta: float) -> void:
	%TotalCaloriesLabel.text = str(GameState.player.character.total_calories)


func _on_eat_button_pressed():
	GameState.actions["EatSomething"].execute({
		"calories_intake": 2,
		"time_to_consume": 10
	})
