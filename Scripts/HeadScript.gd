extends Area2D

@onready var player := get_parent()
@onready var ConcussSnd : AudioStreamPlayer2D = $ConcussSound

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if player.ConcussionTime.is_stopped():
		ConcussSnd.play()
		player.Concuss()
