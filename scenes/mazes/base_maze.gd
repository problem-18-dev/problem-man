class_name Maze
extends TileMapLayer


var grid := AStarGrid2D.new()

func _ready() -> void:
	var grid_size := (get_viewport_rect().size / grid.cell_size).ceil()
	grid.cell_size = tile_set.tile_size
	grid.region = Rect2i(Vector2.ZERO, grid_size)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grid.update()
	
	for cell_position in get_used_cells():
		var data := get_cell_tile_data(cell_position)
		if data and data.get_custom_data("is_wall"):
			grid.set_point_solid(cell_position)


func _draw() -> void:
	for x in grid.region.size.x:
		for y in grid.region.size.y:
			var point := Vector2(x, y)
			var color := Color(1.0, 0.388, 0.32, 0.5) if grid.is_point_solid(point) else Color(0.146, 0.878, 0.577, 0.5)
			draw_rect(Rect2(point * grid.cell_size, grid.cell_size), color)

func position_to_cell(local_position: Vector2) -> Vector2:
	return local_position / grid.cell_size


func get_move_points(start_position: Vector2, end_position: Vector2) -> PackedVector2Array:
	var result = grid.get_point_path(start_position, end_position) as Array[Vector2]
	return result.map(func (point): return point + grid.cell_size / 2.0)


func is_cell_wall(local_position: Vector2) -> bool:
	var cell_position := local_to_map(local_position)
	var cell_data := get_cell_tile_data(cell_position)
	
	return cell_data and cell_data.get_custom_data("is_wall")


func get_cell_center(local_position: Vector2) -> Vector2:
	var cell := local_to_map(local_position)
	return map_to_local(cell)
