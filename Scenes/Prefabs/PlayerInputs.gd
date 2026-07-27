extends Node
var turn: int
var gravity: bool
var RotationInputList : Array = []
var GravityInputList : Array = []
var PlaybackRotationInputList : Array = []
var PlaybackGravityInputList : Array = []
func _ready():
	EventBus.level_completed.connect(_on_level_completed)
# Called every frame. 'delta' is the elapsed time since the previous frame.

var lastRotation : int
var lastGravity : bool
var gravTime : int
var rotTime : int
func _physics_process(delta: float) -> void:
	if GamePlayManager.Playing:
		
		turn = int(Input.get_axis("rotateLeft", "rotateRight"))
		gravity = Input.is_action_pressed("Gravity")
		
		if turn == lastRotation:
			rotTime += 1
		else:
			RotationInputList.append([lastRotation,rotTime])
			lastRotation = turn
			rotTime = 1
		if gravity == lastGravity:
			gravTime += 1
		else:
			GravityInputList.append([lastGravity,gravTime])
			lastGravity = turn
			gravTime = 1
	else:
		if PlaybackRotationInputList != null:
			if PlaybackRotationInputList.front()[1] == 0:
				PlaybackRotationInputList.pop_front()
			turn = PlaybackRotationInputList.front()[0]
		if PlaybackGravityInputList != null:
			if PlaybackGravityInputList.front()[1] == 0:
				PlaybackGravityInputList.pop_front()
			gravity = PlaybackGravityInputList.front()[0]

func _on_level_completed() -> void:
	PlaybackGravityInputList = GravityInputList
	PlaybackRotationInputList = RotationInputList
	get_parent().resetTransform()
	GamePlayManager._on_level_completed()
