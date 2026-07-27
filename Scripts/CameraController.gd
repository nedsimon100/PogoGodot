extends Node

@onready var player := $Player
@onready var cam := $Camera
@onready var floorTxt := $Camera/BackgroundUI/Control/CurrFloorTxt
@onready var TimeTxt := $Camera/BackgroundUI/Control/TimeTxt
var roomHeight : float = 336
var startTime : int


func _process(delta: float) -> void:
	var currfloor : int = round((player.global_position.y)/(roomHeight))*roomHeight
	cam.position = Vector2(0,currfloor)
	floorTxt.text = str(int(-cam.position.y/roomHeight))
	TimeTxt.text = GamePlayManager.playTimeTxt
