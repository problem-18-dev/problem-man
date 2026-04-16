extends Node


const SAVE_PATH := "user://high_score.tres"
const START_LIVES := 5

const STORY_LEVEL_TYPES: Array[GameConfig.LevelType] = [
	GameConfig.LevelType.Tricat,
	GameConfig.LevelType.KeyBricks,
	GameConfig.LevelType.INeedToGo,
	GameConfig.LevelType.CheeseChasers,
]


var main: Main
var save: SaveResource

var previous_level_type: GameConfig.LevelType
var current_level_type: GameConfig.LevelType
var level_type_queue: Array[GameConfig.LevelType] = []

var current_score := 0
var current_level := 1
var current_lives := START_LIVES
var current_phase := GameConfig.Phase.Scatter
var frightened_mode := false
var cruise_elroy := false


func _ready() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		save = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
		return
	
	save = SaveResource.new()


func start_story() -> void:
	# Randomize level types
	level_type_queue = STORY_LEVEL_TYPES.duplicate()
	level_type_queue.shuffle()
	
	# Set previous to classic for transition
	previous_level_type = GameConfig.LevelType.Classic
	
	# Take first level type, transition
	var first_level_type: GameConfig.LevelType = level_type_queue[0]
	current_level_type = first_level_type
	main.load_scene(Main.Scene.Transition)


func start_classic() -> void:
	current_level_type = GameConfig.LevelType.Classic
	main.load_scene(Main.Scene.Game)


func add_score(score: int) -> int:
	current_score += score
	return current_score


func get_current_score() -> int:
	return current_score


func get_high_score() -> int:
	return save.high_score


func save_high_score() -> void:
	if current_score <= 0:
		return
	
	var high_score := save.high_score
	if current_score > high_score:
		save.high_score = current_score
		ResourceSaver.save(save, SAVE_PATH)


func next_level() -> void:
	current_level += 1
	
	# If queue empty, we're in classic.
	if level_type_queue.size() == 0:
		main.load_scene(Main.Scene.Game)
		return
	
	assert(level_type_queue.size() > 1, "Queue has less than 1 level type, this should not happen.")
	
	# If queue has more than 1 level type, pop front, push back
	# Set new first element in array to current level type
	var old_level: GameConfig.LevelType = level_type_queue.pop_front()
	previous_level_type = old_level
	level_type_queue.push_back(old_level)
	current_level_type = level_type_queue[0]
	main.load_scene(Main.Scene.Transition)
	
	

func get_current_level() -> int:
	return current_level


func take_life() -> int:
	current_lives -= 1
	return get_current_lives()


func get_current_lives() -> int:
	return current_lives


func reset() -> void:
	current_score = 0
	current_level = 1
	current_lives = 5
	current_phase = GameConfig.Phase.Scatter
	previous_level_type = GameConfig.LevelType.Classic
	current_level_type = GameConfig.LevelType.Classic
	frightened_mode = false
	cruise_elroy = false


func change_phase(phase: GameConfig.Phase) -> GameConfig.Phase:
	current_phase = phase
	return get_current_phase()


func reset_phase() -> void:
	current_phase = GameConfig.Phase.Scatter


func get_current_phase() -> GameConfig.Phase:
	return current_phase


func toggle_phase() -> void:
	if get_current_phase() == GameConfig.Phase.Scatter:
		change_phase(GameConfig.Phase.Chase)
	else:
		change_phase(GameConfig.Phase.Scatter)


func enable_frightened_mode() -> void:
	frightened_mode = true


func disable_frightened_mode() -> void:
	frightened_mode = false


func get_previous_level_resource() -> LevelResource:
	return GameConfig.LEVEL_RESOURCES[previous_level_type]


func get_current_level_resource() -> LevelResource:
	return GameConfig.LEVEL_RESOURCES[current_level_type]
