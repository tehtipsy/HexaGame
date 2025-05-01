extends PanelContainer


@export var hovering_over_cell = "":
	set(value):
		hovering_over_cell = value

func _on_mouse_entered():
	var rect = Rect2i(Vector2i(global_position), Vector2i(size))
	# set hover offset
	rect.position += Vector2i(40, 0)
	Tooltip.show_tooltip(rect, hovering_over_cell)

func _on_mouse_exited():
	Tooltip.hide_tooltip()
