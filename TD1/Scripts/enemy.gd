class_name Enemy

extends Area2D

@export var speed: float = 200.0
@export var max_life: int = 2
@export var knockback: float = 300.0
@export var knockback_recovery: float = 900.0
@export var explosion_scene: PackedScene

var life: int
var velocity: Vector2

@onready var sprite: Sprite2D = $Sprite2D
@onready var flash_timer: Timer = $FlashTimer

func _ready() -> void:
	life = max_life
	velocity = Vector2.DOWN * speed

# --- 1.4 : descend vers le bas de l'écran, et disparaît une fois sorti
func _physics_process(delta: float) -> void:
	# Juice : après un knockback, on revient progressivement à la vitesse normale
	velocity = velocity.move_toward(Vector2.DOWN * speed, knockback_recovery * delta)
	position += velocity * delta
	# global_position : l'ennemi est enfant du spawner, placé au-dessus de l'écran
	if global_position.y > 800.0:
		queue_free()

func take_damage(amount: int) -> void:
	life -= amount
	if life <= 0:
		die()
		return

	# Juice : flash blanc + knockback
	sprite.modulate = Color(10, 10, 10)
	flash_timer.start()
	velocity.y = -knockback

func _on_flash_timer_timeout() -> void:
	sprite.modulate = Color.WHITE

func die() -> void:
	# Juice : une explosion à la place de l'ennemi
	var explosion: Node2D = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()

# Contact direct avec le joueur
func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		area.take_damage(1)
		die()
