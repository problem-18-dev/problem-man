class_name Maze
extends TileMapLayer


func _ready() -> void:
	NavigationManager.setup(self)


func _draw() -> void:
	var grid := NavigationManager.grid
	for x in grid.region.size.x:
		for y in grid.region.size.y:
			var point := Vector2(x, y)
			var color := Color(1.0, 0.388, 0.32, 0.5) if grid.is_point_solid(point) else Color(0.146, 0.878, 0.577, 0.5)
			draw_rect(Rect2(point * grid.cell_size, grid.cell_size), color)


func is_tile_wall(local_position: Vector2) -> bool:
	var cell_position := local_to_map(local_position)
	var cell_data := get_cell_tile_data(cell_position)
	
	return cell_data and cell_data.get_custom_data("is_wall")


func get_tile_center(local_position: Vector2) -> Vector2:
	var cell := local_to_map(local_position)
	return map_to_local(cell)
