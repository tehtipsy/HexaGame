extends Control


func show_tooltip(pos: Rect2i, data):
	set_tooltip_description(data)
	%TooltipPopup.popup(pos)

func hide_tooltip():
	%TooltipPopup.hide()

func set_tooltip_description(value):
	%TooltipHeader.text = "Hexagon"
	%TooltipDescription.text = value
