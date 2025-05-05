extends Node

class_name GameState

var globalTime: int = 0
var mapNodes = []
class Player:
	var coordinates: Vector2i
var player = Player.new()

func moveGlobalTime(time):
	globalTime += time
	print("time moved! time is now: ", globalTime)

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
		
var actions: Dictionary


	
	
func _movePlayer(position: Vector2i):
	player.coordinates.x = position.x
	player.coordinates.y = position.y

func _takeAShit(_dummy = null):
	print("The player is taking a shit!")
	print("it takes a very long time!")
 
func _init():
	print("this is self", self)
	actions["MovePlayer"] = Action.new(_movePlayer, 1, moveGlobalTime)
	actions["TakeAShit"] = Action.new(_takeAShit, 30, moveGlobalTime)
