class_name CameraShape
extends Camera2D

@export var decay: float = 1.5
@export var max_offset: float = 30.0

var trauma: float = 0.0

func _ready() -> void:
	GameManager.player_life_changed.connect(_on_player_life_changed)

func _process(delta: float) -> void:
	var shake: float = trauma * trauma
	var random_offset_dir: Vector2 = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	)
	offset = random_offset_dir * shake * max_offset
	trauma = max(trauma - decay * delta, 0.0)

func add_trauma(value: float) -> void:
	trauma += value
	trauma = clamp(trauma, 0.0, 1.0)

func _on_player_life_changed(new_life: int) -> void:
	add_trauma(0.6)
	if new_life == 0:
		add_trauma(1.0)
