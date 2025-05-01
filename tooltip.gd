extends Control


func show_tooltip(current_cell):
	set_tooltip_description(current_cell)
	%TooltipPopup.popup()

func hide_tooltip():
	%TooltipPopup.hide()

func set_tooltip_description(value):
	%TooltipDescription.text = value
