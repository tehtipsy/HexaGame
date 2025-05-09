extends Node


signal time_changed(new_time, time_increment)


var globalTime: int = 0
var mapNodes = []


class Player:
	var coordinates: Vector2i


var player = Player.new()


func advanceGlobalTime(time):
	globalTime += time
	print("time changed! time is now: ", globalTime)
	time_changed.emit(globalTime, time)


class Action:
	var _time: int = 0
	var _exec: Callable
	var _moveTime: Callable
	func _init(exec: Callable, time: int, moveTime: Callable):
		_time = time
		_exec = exec
		_moveTime = moveTime
	func execute(args = null):
		_exec.call(args)
		_moveTime.call(_time)


var actions: Dictionary[String, Action]


func _movePlayer(position: Vector2i):
	player.coordinates = position


func _takeAShit(_dummy = null):
	print("The player is taking a shit!")
	print("it takes a very long time!")


func _init():
	actions["MovePlayer"] = Action.new(_movePlayer, 1, advanceGlobalTime)
	actions["TakeAShit"] = Action.new(_takeAShit, 30, advanceGlobalTime)
