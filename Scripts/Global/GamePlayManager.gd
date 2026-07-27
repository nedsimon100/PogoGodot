extends Node

enum  SceneType {Timed,Endless,Menu}
enum gameStates {Playing,Paused,Playback}
var gameState : gameStates = gameStates.Playing
var GameMode : SceneType = SceneType.Timed
func _ready() -> void:
	StartGame()


func _process(delta: float) -> void:
	match GameMode:
		SceneType.Menu:
			pass
		SceneType.Timed:
			if 	gameState == gameStates.Playing:
				playTimeNum = Time.get_ticks_msec()-startTime
				playTimeTxt = convertTime(playTimeNum)
		SceneType.Endless:
			pass

var playTimeTxt : String
var playTimeNum : int
var startTime : int
var startPauseTime: int

func StartGame() -> void:
	if GameMode == SceneType.Timed:
		startTime = Time.get_ticks_msec()
	gameState = gameStates.Playing
var PlaybackArray: Array

func _on_level_completed(inputArray: Array) -> void:
	PlaybackArray = inputArray
	gameState = gameStates.Playback
	get_tree().reload_current_scene()



func PauseGame() -> void:
	if GameMode == SceneType.Timed:
		startPauseTime = Time.get_ticks_msec()
	Engine.time_scale = 0
	gameState = gameStates.Playing

func ResumeGame() -> void:
	Engine.time_scale = 1
	if GameMode == SceneType.Timed:
		startTime += Time.get_ticks_msec() - startPauseTime
	gameState = gameStates.Playing



func convertTime(miliSecs: int) -> String:
	#var ms : String = str(miliSecs % 1000).pad_zeros(3)
	var ss : String = str(int(miliSecs / 1000) % 60).pad_zeros(2)
	var mm : String = str(int(miliSecs / 60000) % 60).pad_zeros(2)
	var hh : String = str(int(miliSecs / 3600000)).pad_zeros(2)
	
	return hh+":"+mm+":"+ss#+":"+ms
