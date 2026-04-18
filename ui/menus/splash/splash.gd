extends Control


func _input(event: InputEvent) -> void:
	if event.is_action("interact"):
		go_to_game()


func go_to_game() -> void:
	GameManager.main.load_scene(Main.Scene.MainMenu)
