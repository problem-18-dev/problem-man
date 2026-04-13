class_name Main
extends Node


signal scene_changed(scene: Scene)

enum Scene { Game }

@export_category("Scenes")
@export var first_scene := Scene.Game

var scenes := {
	Scene.Game: "res://scenes/game/game.tscn",
}

var current_scene: Node
var level_types := GameConfig.LEVEL_RESOURCES.keys()


func _ready() -> void:
	GameManager.main = self
	load_scene(first_scene)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_toggle_level_resource()


func unload_scene() -> void:
	if current_scene:
		remove_child(current_scene)
		current_scene.queue_free()
		current_scene = null


func load_scene(scene: Scene) -> void:
	unload_scene()
	var new_scene: PackedScene = load(scenes[scene])
	current_scene = new_scene.instantiate()
	add_child(current_scene)
	scene_changed.emit(scene)


var pointer := 1


func _toggle_level_resource() -> void:
	if pointer == level_types.size():
		pointer = 0
	
	GameManager.current_level_type = level_types[pointer]
	pointer += 1
	load_scene(Scene.Game)
