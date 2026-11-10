extends Node

@export var score: int = 0

var life: int

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

signal score_changed(score: int)
signal player_life_changed(life: int)
signal game_over()

func add_score(points: int) -> void:
	score += points
	score_changed.emit(score)

func trigger_game_over() -> void:
	Engine.time_scale = 0.3
	await get_tree().create_timer(1.0, true, false, true).timeout
	Engine.time_scale = 1.0
	get_tree().paused = true
	game_over.emit()

func restart() -> void:
	score = 0
	get_tree().paused = false
	score_changed.emit(score)
	get_tree().reload_current_scene()
	
func hitstop(duration: float) -> void:
	Engine.time_scale = 0.05
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
