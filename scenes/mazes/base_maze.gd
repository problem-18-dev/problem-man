class_name Maze
extends TileMapLayer


const FRUIT_SPAWN_LOCATION := Vector2(224, 248)

signal score_added(score: int)
signal powerup_eaten
signal level_ended
signal cruise_elroy_triggered

var _fruit_scene: PackedScene = preload("res://scenes/edibles/fruit/fruit.tscn")
var _pellet_scene: PackedScene = preload("res://scenes/edibles/pellet/pellet.tscn")
var _powerup_scene: PackedScene = preload("res://scenes/edibles/power_up/power_up.tscn")
var _total_pellets := 0

@onready var pellets: Node2D = $Pellets
@onready var fruits: Node2D = $Fruits
@onready var power_ups: Node2D = $PowerUps


func _ready() -> void:
	NavigationManager.setup(self)
	_change_maze()
	_spawn_pellets()


func is_tile_wall(local_position: Vector2) -> bool:
	var cell_position := local_to_map(local_position)
	var cell_data := get_cell_tile_data(cell_position)
	
	return cell_data and cell_data.get_custom_data("is_wall")


func get_tile_center(local_position: Vector2) -> Vector2:
	var cell := local_to_map(local_position)
	return map_to_local(cell)


func _change_maze() -> void:
	var level_resource := GameConfig.get_current_level_resource()
	tile_set.get_source(2).texture = level_resource.maze_texture


func _spawn_fruit() -> void:
	if fruits.get_child_count() > 0:
		return
	
	var fruit: Edible = _fruit_scene.instantiate()
	fruit.position = FRUIT_SPAWN_LOCATION
	fruit.eaten.connect(_on_fruit_eaten)
	fruits.call_deferred("add_child", fruit)


func _spawn_pellets() -> void:
	for cell in get_used_cells():
		var cell_data := get_cell_tile_data(cell)
		if cell_data:
			if cell_data.get_custom_data("is_pellet"):
				var pellet: Area2D = _pellet_scene.instantiate()
				pellet.position = map_to_local(cell)
				pellet.eaten.connect(_on_pellet_eaten)
				pellets.add_child(pellet)
				continue
			
			if cell_data.get_custom_data("is_powerup"):
				var powerup: Area2D = _powerup_scene.instantiate()
				powerup.position = map_to_local(cell)
				powerup.power_up_eaten.connect(_on_powerup_eaten)
				power_ups.add_child(powerup)
	
	_total_pellets = pellets.get_child_count()


func _on_powerup_eaten() -> void:
	powerup_eaten.emit()


func _on_fruit_eaten(score: int) -> void:
	score_added.emit(score)


func _on_pellet_eaten(score: int) -> void:
	var pellets_left := pellets.get_child_count()
	var pellets_eaten := _total_pellets - pellets_left
	
	if pellets_eaten == 25 or pellets_eaten == 170:
		_spawn_fruit()
	
	if pellets_left < 20:
		cruise_elroy_triggered.emit()
	
	if pellets_left <= 1:
		level_ended.emit()
	
	score_added.emit(score)
