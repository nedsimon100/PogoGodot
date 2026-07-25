extends Node

@onready var player := $Player
@onready var cam := $Camera
var roomHeight : float = 300

func _process(delta: float) -> void:
	var currfloor : int = round((player.global_position.y)/(roomHeight))*roomHeight
	cam.position = Vector2(0,currfloor)
