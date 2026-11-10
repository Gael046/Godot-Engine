class_name Player

extends Area2D

@export var speed: float = 600.0
@export var acceleration: float = 4000.0
@export var max_tilt_degrees: float = 15.0
@export var x_limit: float = 320.0
@export var max_life: int = 3
@export var explosion_scene: PackedScene
@export var invincibility_duration: float = 1.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var damage: AudioStreamPlayer2D = $Damage

var velocity: Vector2 = Vector2.ZERO
var life: int
var invincibility_time: float = 1.0

func _ready() -> void:
	life = max_life
	GameManager.player_life_changed.emit(life)

func _physics_process(delta: float) -> void:
	if invincibility_time > 0.0:
		invincibility_time -= delta
	var target_velocity: Vector2 = read_direction() * speed
	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	position += velocity * delta
	position.x = clamp(position.x, -x_limit, x_limit)
	sprite.rotation = deg_to_rad(max_tilt_degrees) * velocity.x / speed

func read_direction() -> Vector2:
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	if Input.is_action_pressed("touch"):
		var distance_to_finger: float = get_global_mouse_position().x - global_position.x
		direction.x = clamp(distance_to_finger / 60.0, -1.0, 1.0)
	return direction

func take_damage(amount: int) -> void:
	if invincibility_time == 1.0:
		return
	
	invincibility_time = 0.0
	var blink_tween: Tween = get_tree().create_tween()
	blink_tween.tween_property(sprite, "modulate:a", 0.4, 0.25)
	blink_tween.tween_property(sprite, "modulate:a", 1.0, 0.25)
	blink_tween.set_loops(2)
	blink_tween.play()
	
	life -= amount
	damage.play()
	GameManager.hitstop(0.1)
	GameManager.player_life_changed.emit(life)
	
	if life <= 0:
		var explosion: Node2D = explosion_scene.instantiate()
		explosion.global_position = global_position
		explosion.scale = Vector2.ONE * 2.0
		get_tree().current_scene.add_child(explosion)
		GameManager.trigger_game_over()
