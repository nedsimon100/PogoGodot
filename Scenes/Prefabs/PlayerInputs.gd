extends Node
var turn: int
var gravity: bool
var RotationInputList : Array = []
var GravityInputList : Array = []

func _ready():
	EventBus.level_completed.connect(_on_level_completed)
	lastRotation = 0
	lastGravity = false
	if GamePlayManager.gameState == GamePlayManager.gameStates.Playback:
		RotationInputList = GamePlayManager.PlaybackArray[0].duplicate(true)
		GravityInputList  = GamePlayManager.PlaybackArray[1].duplicate(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.

var lastRotation : int
var lastGravity : bool
var gravTime : int
var rotTime : int
func GetInputs() -> void:
	match GamePlayManager.gameState:
		GamePlayManager.gameStates.Playing:
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
				lastGravity = gravity
				gravTime = 1
		GamePlayManager.gameStates.Playback:
			if not RotationInputList.is_empty():
				turn = RotationInputList.front()[0]
				RotationInputList.front()[1] -= 1
				if RotationInputList.front()[1] == 0:
					RotationInputList.pop_front()
				
			if not GravityInputList.is_empty():
				gravity = GravityInputList.front()[0]
				GravityInputList.front()[1] -= 1
				if GravityInputList.front()[1] == 0:
					GravityInputList.pop_front()
				

func _on_level_completed() -> void:
	if GamePlayManager.gameState == GamePlayManager.gameStates.Playing:
		RotationInputList.append([lastRotation,rotTime])
		GravityInputList.append([lastGravity,gravTime])
		var allInputs : Array = [RotationInputList,GravityInputList]
		GamePlayManager._on_level_completed(allInputs)
	else:
		GamePlayManager._on_level_completed(GamePlayManager.PlaybackArray)
