class_name Character extends Control


@export var total_calories: int = 0


var inventory = {
	"slected_slot": "",
	"backpack_slot": "",
	"satchel_slot": "",
	"waterskin_slot": ""
}


func _process(delta: float) -> void:
	%TotalCaloriesLabel.text = str(GameState.player.character.total_calories)


func _calc_calories_cost(item):
	return item.gain - item.cost


func _on_eat_button_pressed():
	var item = GameState.player.character.inventory.slected_slot
	GameState.actions["EatSomething"].execute({
		"calories_intake": _calc_calories_cost(item),
		"duration": 10
	})
