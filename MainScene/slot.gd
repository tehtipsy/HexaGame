extends PanelContainer

@export var base_offset: int = 40
@export var hovering_over_cell = "":
	set(value):
		hovering_over_cell = value

func _on_mouse_entered():
	var rect = Rect2i(Vector2i(global_position), Vector2i(size))
	# set hover offset
	var screen_width = get_viewport_rect().size.x
	var mouse_x = get_global_mouse_position().x
	if mouse_x < screen_width / 4:
			rect.position += Vector2i(base_offset, 0) # Add offset if mouse is on the left
	else:
			rect.position -= Vector2i(size.x + (1.25 * base_offset), 0) # Subtract offset if mouse is on the right

	Tooltip.show_tooltip(rect, hovering_over_cell)

func _on_mouse_exited():
	Tooltip.hide_tooltip()
