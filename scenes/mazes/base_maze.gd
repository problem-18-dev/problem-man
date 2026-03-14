class_name Maze
extends TileMapLayer


signal score_added(score: int)


var _fruit_scene: PackedScene = preload("res://scenes/edibles/fruit/fruit.tscn")
var _pellet_scene: PackedScene = preload("res://scenes/edibles/pellet/pellet.tscn")
var _total_pellets := 0

@onready var pellets: Node2D = $Pellets
@onready var fruits: Node2D = $Fruits
@onready var power_ups: Node2D = $PowerUps


func _ready() -> void:
	NavigationManager.setup(self)
	_spawn_pellets()


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


func _spawn_fruit() -> void:
	if fruits.get_child_count() > 0:
		return
	
	var spawn_location := Vector2(224, 248)
	var fruit: Edible = _fruit_scene.instantiate()
	fruit.position = spawn_location
	fruit.eaten.connect(_on_fruit_eaten)
	fruits.call_deferred("add_child", fruit)


func _spawn_pellets() -> void:
	for cell in get_used_cells():
		var cell_data := get_cell_tile_data(cell)
		if cell_data and cell_data.get_custom_data("is_pellet"):
			var pellet: Area2D = _pellet_scene.instantiate()
			pellet.position = map_to_local(cell)
			pellet.eaten.connect(_on_pellet_eaten)
			pellets.add_child(pellet)
	
	_total_pellets = pellets.get_child_count()


func _on_fruit_eaten(score: int) -> void:
	score_added.emit(score)


func _on_pellet_eaten(score: int) -> void:
	var pellets_left := pellets.get_child_count()
	var pellets_eaten := _total_pellets - pellets_left
	
	if pellets_eaten == 25 or pellets_eaten == 170:
		_spawn_fruit()
	
	score_added.emit(score)
