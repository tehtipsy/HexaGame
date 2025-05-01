extends PanelContainer


@export var hovering_over_cell = "":
	set(value):
		hovering_over_cell = value

func _on_mouse_entered():
	print('hovering_over_cell: ', hovering_over_cell)
	Tooltip.show_tooltip(hovering_over_cell)

func _on_mouse_exited():
	Tooltip.hide_tooltip()
