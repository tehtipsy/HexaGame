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
	GameState.player.coordinates = starting_tile_coors
	print("starting_tile_coors: ", starting_tile_coors)
	_place_player_tile(starting_tile_coors)
	_set_tooltip_text(starting_tile_coors, " Starting Tile")

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


func _place_blue_tile(tile_position):
	var tile_atlas_coords = Vector2i(0,0) # get from card holder
	set_cell(tile_color_layer, tile_position, tile_color_id, tile_atlas_coords)


func _place_player_tile(tile_position):
	set_cell(tile_color_layer, tile_position, tile_color_id, Vector2i(3, 0))


func _set_tooltip_text(tile_position, text):
	cell_slots[tile_position].hovering_over_cell += text


func _handle_click(tile_position):
	if GameState.player.coordinates == tile_position:
		GameState.actions["TakeAShit"].execute()
	else:
		_place_blue_tile(GameState.player.coordinates)
		GameState.actions["MovePlayer"].execute(tile_position)
		_place_player_tile(tile_position)


func _input(event):
	if event is InputEventMouseButton:
		var _global_position = get_global_mouse_position()
		var tile_position = local_to_map(to_local(_global_position))
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			_handle_click(tile_position)
