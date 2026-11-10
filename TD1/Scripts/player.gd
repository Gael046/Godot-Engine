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

# --- 1.2 : déplacement. Le Player a une collision, donc on le bouge dans _physics_process
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
	# Au doigt (ou à la souris) : on rejoint la position X du doigt, en ralentissant à l'approche
	if Input.is_action_pressed("touch"):
		var distance_to_finger: float = get_global_mouse_position().x - global_position.x
		direction.x = clamp(distance_to_finger / 60.0, -1.0, 1.0)
	return direction

# --- 1.4 : dégâts (appelé par les ennemis)
func take_damage(amount: int) -> void:
	life -= amount
	if life <= 0:
		# Pour l'instant, la partie recommence. Le vrai game over arrive en 1.5
		# call_deferred : on est en pleine collision, on recharge à la fin de la frame
		get_tree().reload_current_scene.call_deferred()
