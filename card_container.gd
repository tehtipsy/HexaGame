extends Container


@export var is_higlighted: bool = false

#@onready var tile_map = preload("res://tile_map.tscn")
@onready var card = preload("res://card_holder.tscn")
@onready var animation = $AnimationPlayer


func _on_mouse_entered():
	animation.play("select_card")
	is_higlighted = true


func _on_mouse_exited():
	animation.play("deselect_card")
	is_higlighted = false


func _on_gui_input(event):
	if (event is InputEventMouseButton) and (event.button_index == 1):
		if event.button_mask == 1:
			if is_higlighted:
				var _card = card.instanciate()
				get_tree().get_root().get_node("CardHolder").add_child(_card)
				# hide card sprite in container
				self.get_child(0).hide()
		elif event.button_mask == 0:
			# check for valid placement
			var tile_map = get_tree().get_root().get_node("TileMap")
			var max_x = tile_map.map_width
			var max_y = tile_map.map_hight

			var _global_position = get_global_mouse_position()
			var tile_position = tile_map.local_to_map(tile_map.to_local(_global_position))

			var is_placement_valid: bool
			if (tile_position.x <= max_x) and (tile_position.y <= max_y):
				is_placement_valid = true

			if !is_placement_valid:
			# return card to card container
				is_higlighted = false
				# show sprite in card container
				self.get_child(0).show()
			else:
			# place card in tile
				# remove child _card instance
				self.queue_free()
				# set tile in node
				var atlas_coords = Vector2i(0, 0)
				tile_map.set_cell(tile_map.tile_color_layer, tile_position, tile_map.tile_color_id, atlas_coords)
			# set is_placement_valid = false

