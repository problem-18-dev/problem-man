class_name Main
extends Node


enum Scene { MainMenu, Transition, Game }

@export_category("Scenes")
@export var first_scene := Scene.Game

var scenes := {
	Scene.MainMenu: "res://scenes/ui/main_menu/main_menu.tscn",
	Scene.Transition: "res://ui/menus/transition/transition.tscn",
	Scene.Game: "res://scenes/game/game.tscn",
}

var current_scene: Node


func _ready() -> void:
	GameManager.main = self
	load_scene(first_scene)


func unload_scene() -> void:
	if current_scene:
		call_deferred("remove_child", current_scene)
		current_scene.queue_free()
		current_scene = null


func load_scene(scene: Scene) -> void:
	unload_scene()
	var new_scene: PackedScene = load(scenes[scene])
	current_scene = new_scene.instantiate()
	add_child(current_scene)
