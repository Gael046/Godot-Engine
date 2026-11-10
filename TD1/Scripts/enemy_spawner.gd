extends Node2D

@export var enemy_scene: PackedScene
@export var x_range: float = 300.0

# --- 1.4 : un ennemi à chaque fin du Timer
func _on_timer_timeout() -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.position = Vector2(randf_range(-x_range, x_range), 0)
	add_child(enemy)
