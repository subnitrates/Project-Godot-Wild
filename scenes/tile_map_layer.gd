extends TileMapLayer

@export var width: int = 50
@export var height: int = 30
@export var floor_tile_source_id: int = 2 
@export var wall_tile_source_id: int = 0
@export var floor_tile_coords: Vector2i = Vector2i(0, 0) 
@export var top_wall_tile_coords: Vector2i = Vector2i(0, 1) 
@export var bottom_wall_tile_coords: Vector2i = Vector2i(0, 2) 

func _ready():
	generate_level()

func generate_level():
	for x in range(width):
		for y in range(height):
			if y == 0:
				set_cell(Vector2i(x, y), wall_tile_source_id, top_wall_tile_coords)
			elif y == height - 1:
				set_cell(Vector2i(x, y), wall_tile_source_id, bottom_wall_tile_coords)
			else:
				set_cell(Vector2i(x, y), floor_tile_source_id, floor_tile_coords)
