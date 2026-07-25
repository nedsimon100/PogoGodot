extends Area2D

@onready var player := get_parent()
@onready var ConcussSnd : AudioStreamPlayer2D = $ConcussSound
var collisionCount:int

func _physics_process(delta: float) -> void:
	if has_overlapping_bodies():
		if player.ConcussionTime.is_stopped():
			ConcussSnd.play()
			player.Concuss()
