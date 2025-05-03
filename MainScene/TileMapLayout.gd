extends TileMap

const SlotScene = preload("res://MainScene/slot.tscn")

@export var map_width: int = 15
@export var map_height: int = 6
@export var tile_types: int = 3  # Adjust this to match the number of different tile types you have
# @export var alt_types: int = 3

# Atlas IDs
@export var tile_color_id = 0
@export var tile_in_arrow_id = 1
@export var tile_out_arrow_id = 2

# Layer IDs
@export var tile_color_layer = 0
@export var tile_in_arrow_layer = 1
@export var tile_out_arrow_layer = 2

@onready var slot_container = get_node("../SlotContainer")

var cell_slots = {}

func _ready():
	clear()
	_clear_cell_slots()
	_generate_random_map()
	_create_cell_slots()
	_set_starting_tile()

func _set_starting_tile():
	var starting_tile_coors = Vector2i(randi() % map_width, randi() % map_height)
	print("starting_tile_coors: ", starting_tile_coors)
	set_cell(tile_color_layer, starting_tile_coors, tile_color_id, Vector2i(3, 0))
	cell_slots[starting_tile_coors].hovering_over_cell += " Starting Tile"

func _clear_cell_slots():
	# Ensure the container is valid before trying to access children
	if not is_instance_valid(slot_container):
		printerr("SlotContainer node is not valid or not found.")
		return
	for child in slot_container.get_children():
		child.queue_free()
	cell_slots.clear()

func _generate_random_map():
	for x in range(map_width):
		for y in range(map_height):
			var random_tile = randi() % tile_types
			set_cell(tile_color_layer, Vector2i(x, y), tile_color_id, Vector2i(random_tile, 0))

func _create_cell_slots():
	if not SlotScene:
		printerr("SlotScene not loaded!")
		return
	if not is_instance_valid(slot_container):
		printerr("SlotContainer node not found or invalid!")
		return

	# Ensure tile_set is valid before proceeding
	if not tile_set:
		printerr("TileSet is not assigned to the TileMap!")
		return

	for x in range(map_width):
		for y in range(map_height):
			var cell_coords = Vector2i(x, y)

			# Optional: Only create a slot if a tile exists there
			# You might want a slot even on empty cells, depending on game logic
			# if get_cell_source_id(tile_color_layer, cell_coords) == -1:
			#	 continue

			var slot_instance = SlotScene.instantiate()

			# Calculate the world position for the center of the cell
			var world_pos = map_to_local(cell_coords)

			var slot_size = Vector2(40, 40) # Get this dynamically if possible
			world_pos -= slot_size / 2.0

			slot_instance.position = world_pos
			# 1. Create the string value you want to set
			var cell_coords_string = str(cell_coords)
			# 2. Assign the string to the property. This executes the set() function in slot.gd
			slot_instance.hovering_over_cell = cell_coords_string

			slot_container.add_child(slot_instance)

			# Store a reference to access/update this slot later
			cell_slots[cell_coords] = slot_instance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _handle_arrow(instruction, arrow_layer, arrow_id, tile_position):
	var current_arrow_atlas_coords = get_cell_atlas_coords(arrow_layer, tile_position)
	#print("arrow atlas coords: ", current_arrow_atlas_coords)
	if current_arrow_atlas_coords.x >= 0:
		var new_in_arrow_atlas_coords = Vector2i(current_arrow_atlas_coords.x + 1, current_arrow_atlas_coords.y)
		if new_in_arrow_atlas_coords.x > 5:
			new_in_arrow_atlas_coords.x = 0
		if instruction == 'remove':
			new_in_arrow_atlas_coords = Vector2i(-1, -1)
		set_cell(arrow_layer, tile_position, arrow_id, new_in_arrow_atlas_coords)
	else:
		var arrow_atlas_coords = Vector2i(0, 0)
		set_cell(arrow_layer, tile_position, arrow_id, arrow_atlas_coords)

func _place_card(tile_position):
	var tile_atlas_coords = Vector2i(0,0) # get from card holder
	set_cell(tile_color_layer, tile_position, tile_color_id, tile_atlas_coords)


func _handle_click(tile_position):
# func _handle_click(instruction, arrow_layer, arrow_id, tile_position):
	# Get the tile data
	var tile_data = get_cell_tile_data(tile_color_layer, tile_position)
	if tile_data:
		var _current_source_id = get_cell_source_id(tile_color_layer, tile_position)
		var _current_atlas_coords = get_cell_atlas_coords(tile_color_layer, tile_position)
		#print("Tile source_id: ", current_source_id)
		#print("Tile atlas coords: ", current_atlas_coords)
		# if current_atlas_coords.x == 2 and current_source_id == 0: # white tile
		# 	_handle_arrow(instruction, arrow_layer, arrow_id, tile_position)
		_place_card(tile_position)

func _input(event):
	if event is InputEventMouseButton:
		var _global_position = get_global_mouse_position()
		var tile_position = local_to_map(to_local(_global_position))
		#print("Tile X: ", tile_position.x)
		if !Input.is_key_pressed(KEY_SHIFT):
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				#print("Clicked tile: ", tile_position)
				# _handle_click('add', tile_in_arrow_layer, tile_in_arrow_id, tile_position)
				_handle_click(tile_position)
			# if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			# 	_handle_click('remove', tile_in_arrow_layer, tile_in_arrow_id, tile_position)
		#else:
			#print('SHIFTING')
			#if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				#_handle_click('add', tile_out_arrow_layer, tile_out_arrow_id, tile_position)
			#if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
				#_handle_click('remove', tile_out_arrow_layer, tile_out_arrow_id, tile_position)
