extends Node


const REGION := Rect2i(0, 0, 28, 30)
const CELL_SIZE := Vector2i(16, 16)

var grid := AStarGrid2D.new()


func _ready() -> void:
	grid.region = REGION
	grid.cell_size = CELL_SIZE
	grid.offset = CELL_SIZE * 0.5
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grid.update()


func setup(maze: Maze) -> void:
	for cell_position in maze.get_used_cells():
		if not REGION.has_point(cell_position):
			continue
		
		var data := maze.get_cell_tile_data(cell_position)
		if data and data.get_custom_data("is_wall"):
			grid.set_point_solid(cell_position)


func position_to_cell(local_position: Vector2) -> Vector2:
	return local_position / grid.cell_size


func get_random_cell() -> Vector2:
	var random_cell := Vector2(randi_range(0, REGION.size.x), randi_range(0, REGION.size.y))
	return random_cell


func get_move_points(start_position: Vector2, end_position: Vector2) -> PackedVector2Array:
	var max_point := Vector2(REGION.size) - Vector2.ONE
	var start_clamped := start_position.clamp(Vector2.ZERO, max_point)
	var end_clamped := end_position.clamp(Vector2.ZERO, max_point)
	var result = grid.get_point_path(start_clamped, end_clamped, true) as Array[Vector2]
	return result
