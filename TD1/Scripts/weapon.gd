class_name Weapon

extends Node2D

@export var bullet_scene: PackedScene
@export var time_between_shots: float = 0.2
@export var spread_degrees: float = 3.0
@export var muzzle_flash_scene: PackedScene

var cooldown: float = 0.0

@onready var sound: AudioStreamPlayer2D = $Sound

func _ready() -> void:
	cooldown = time_between_shots

# --- 1.3 : tir automatique, avec un cooldown décompté grâce à delta
func _process(delta: float) -> void:
	cooldown -= delta
	if cooldown <= 0.0:
		shoot()
		cooldown = time_between_shots

func shoot() -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	# Le tir part dans la direction de l'arme. Juice : légère dispersion
	bullet.rotation = global_rotation + deg_to_rad(randf_range(-spread_degrees, spread_degrees))
	get_tree().current_scene.add_child(bullet)

	# Juice : son (le .tres fourni fait varier le pitch) + flash au bout du canon
	sound.play()
	if muzzle_flash_scene:
		add_child(muzzle_flash_scene.instantiate())
