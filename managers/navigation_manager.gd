extends Node


const TILE_SIZE := Vector2(16, 16)

var grid := AStarGrid2D.new()


func _ready() -> void:
	grid.cell_size = TILE_SIZE
	var grid_size := (get_viewport().get_visible_rect().size / TILE_SIZE).ceil()
	grid.region = Rect2i(Vector2.ZERO, grid_size)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grid.update()


func setup(maze: Maze) -> void:
	for cell_position in maze.get_used_cells():
		var data := maze.get_cell_tile_data(cell_position)
		if data and data.get_custom_data("is_wall"):
			grid.set_point_solid(cell_position)


func position_to_cell(local_position: Vector2) -> Vector2:
	return local_position / grid.cell_size


func get_move_points(start_position: Vector2, end_position: Vector2) -> PackedVector2Array:
	var end_position_clamped := end_position.clamp(Vector2.ZERO, grid.region.size)
	var result = grid.get_point_path(start_position, end_position_clamped, true) as Array[Vector2]
	return result.map(func (point): return point + grid.cell_size / 2.0)
