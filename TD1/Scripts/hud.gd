extends CanvasLayer

@onready var score_label: Label = $Label
@onready var life_container: HBoxContainer = $HBoxContainer
@onready var panel: Control = $Panel

func _ready() -> void:
	panel.visible = false
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.player_life_changed.connect(_on_player_life_changed)

func _process(delta: float) -> void:
	pass

func _on_score_changed(new_score: int) -> void:
	score_label.text = str(new_score)

func _on_player_life_changed(new_life: int) -> void:
	for i: int in life_container.get_child_count():
		life_container.get_child(i).visible = i < new_life
	if(new_life == 0):
		panel.visible = true

func _on_button_pressed() -> void:
	GameManager.restart()

func _on_button_2_pressed() -> void:
	get_tree().quit()
