class_name Enemy

extends Area2D

@export var speed: float = 200.0
@export var max_life: int = 2
@export var knockback: float = 300.0
@export var knockback_recovery: float = 900.0
@export var explosion_scene: PackedScene
@export var debri_scene: PackedScene

var life: int
var velocity: Vector2
var scale_tween: Tween

@onready var sprite: Sprite2D = $Sprite2D
@onready var flash_timer: Timer = $FlashTimer

func _ready() -> void:
	life = max_life
	velocity = Vector2.DOWN * speed

func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.DOWN * speed, knockback_recovery * delta)
	position += velocity * delta
	if global_position.y > 800.0:
		queue_free()

func take_damage(amount: int) -> void:
	life -= amount
	if life <= 0:
		die()
		return

	sprite.modulate = Color(10, 10, 10)
	flash_timer.start()
	velocity.y = -knockback
	
	if scale_tween != null and scale_tween.is_valid():
		scale_tween.kill()
	scale_tween = get_tree().create_tween()
	scale_tween.tween_property(sprite, "scale", Vector2(1.3, 0.7), 0.08)
	scale_tween.tween_property(sprite, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _on_flash_timer_timeout() -> void:
	sprite.modulate = Color.WHITE

func die() -> void:
	GameManager.add_score(10) # Ajoute 10 au score
	var explosion: Node2D = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	
	var debri: Node2D = debri_scene.instantiate()
	debri.global_position = global_position
	get_tree().current_scene.add_child(debri)
	
	var camera: CameraShape = get_viewport().get_camera_2d()
	camera.add_trauma(1.0)
	GameManager.hitstop(0.04)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		area.take_damage(1)
		die()
