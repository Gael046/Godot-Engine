extends CanvasLayer

@onready var score_label: Label = $Label
@onready var life_container: HBoxContainer = $HBoxContainer
@onready var panel: Control = $Panel
@onready var damage_flash: ColorRect = $ColorRect

func _ready() -> void:
	panel.visible = false
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.player_life_changed.connect(_on_player_life_changed)

func _process(delta: float) -> void:
	pass

func _on_score_changed(new_score: int) -> void:
	score_label.pivot_offset = score_label.size / 2
	score_label.scale = Vector2(1.4, 1.4)
	
	var punch_tween: Tween = get_tree().create_tween()
	punch_tween.tween_property(score_label, "scale", Vector2.ONE, 0.25)
	punch_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	score_label.text = str(new_score)

func _on_player_life_changed(new_life: int) -> void:
	damage_flash.color = Color(1, 0, 0, 0.4)
	var flash_tween: Tween = get_tree().create_tween()
	flash_tween.tween_property(damage_flash, "color", Color(1, 0, 0, 0), 0.25)
	flash_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	for i: int in life_container.get_child_count():
		life_container.get_child(i).visible = i < new_life
	if(new_life == 0):
		panel.visible = true
		panel.pivot_offset = panel.size / 2
		panel.scale = Vector2(0.3, 0.3)
		panel.modulate.a = 0.0
		var panel_tween: Tween = get_tree().create_tween()
		panel_tween.set_parallel(true)
		panel_tween.tween_property(panel, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		panel_tween.tween_property(panel, "modulate:a", 1.0, 0.3)

func _on_button_pressed() -> void:
	GameManager.restart()

func _on_button_2_pressed() -> void:
	get_tree().quit()
