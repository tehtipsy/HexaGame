extends Control


func show_tooltip(position: Rect2i, data):
	set_tooltip_description(data)
	%TooltipPopup.popup(position)

func hide_tooltip():
	%TooltipPopup.hide()

func set_tooltip_description(value):
	%TooltipHeader.text = "Hexagon"
	%TooltipDescription.text = value
