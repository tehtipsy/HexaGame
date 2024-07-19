extends TileMap


# Called when the node enters the scene tree for the first time.

@export var map_width: int = 50
@export var map_height: int = 20
@export var tile_types: int = 3  # Adjust this to match the number of different tile types you have

func _ready():
	generate_random_map()

func generate_random_map():
	for x in range(map_width):
		for y in range(map_height):
			var random_tile = randi() % tile_types
			set_cell(0, Vector2i(x, y), 0, Vector2i(random_tile, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			print('clicked')
			generate_random_map()
