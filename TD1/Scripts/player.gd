class_name Player

extends Area2D

@export var speed: float = 600.0
@export var acceleration: float = 4000.0
@export var max_tilt_degrees: float = 15.0
@export var x_limit: float = 320.0
@export var max_life: int = 3

var velocity: Vector2 = Vector2.ZERO
var life: int

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	life = max_life
	GameManager.player_life_changed.emit(life)

func _physics_process(delta: float) -> void:
	var target_velocity: Vector2 = read_direction() * speed
	# Juice : accélération et freinage progressifs, le vaisseau a du poids
	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	position += velocity * delta
	position.x = clamp(position.x, -x_limit, x_limit)
	# Juice : le vaisseau s'incline dans le sens du mouvement
	sprite.rotation = deg_to_rad(max_tilt_degrees) * velocity.x / speed

func read_direction() -> Vector2:
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	if Input.is_action_pressed("touch"):
		var distance_to_finger: float = get_global_mouse_position().x - global_position.x
		direction.x = clamp(distance_to_finger / 60.0, -1.0, 1.0)
	return direction

func take_damage(amount: int) -> void:
	life -= amount
	GameManager.player_life_changed.emit(life)
	if life <= 0:
		GameManager.trigger_game_over()
