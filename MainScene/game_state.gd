extends Node


signal time_changed(new_time, time_increment)


var globalTime: int = 0
var mapNodes = []


class Player:
	var coordinates: Vector2i
	var character: Character
	func _init():
		character = Character.new()


var player = Player.new()


func advanceGlobalTime(time):
	globalTime += time
	print("time changed! time is now: ", globalTime)
	time_changed.emit(globalTime, time)


class Action:
	var _time: Callable
	var _exec: Callable
	var _moveTime: Callable
	func _init(exec: Callable, time: Callable, moveTime: Callable):
		_time = time
		_exec = exec
		_moveTime = moveTime
	func execute(args = null):
		_exec.call(args)
		_moveTime.call(_time.call(args))


var actions: Dictionary[String, Action]


func _movePlayer(position: Vector2i):
	player.coordinates = position


func _takeAShit(_dummy = null):
	print("it takes a very long time!")
	if _dummy:
		match _dummy.type:
			"Forage":
				pass
			"Bushcraft":
				pass
			"Navigate":
				pass


func _increase_calories(args):
	player.character.total_calories += args.calories_intake
	advanceGlobalTime(args.time_to_consume)


func _action_time(_dummy = null):
	return 1


func _init():
	actions["MovePlayer"] = Action.new(_movePlayer, _action_time, advanceGlobalTime)
	actions["TakeAShit"] = Action.new(_takeAShit, _action_time, advanceGlobalTime) # Action with optinal args
	actions["EatSomething"] = Action.new(_increase_calories, _action_time, advanceGlobalTime) # Dynamic time change

	# Player Actions
	actions["Forage"] = Action.new(_takeAShit, _action_time, advanceGlobalTime)
	actions["Bushcraft"] = Action.new(_takeAShit, _action_time, advanceGlobalTime)
	actions["Navigate"] = Action.new(_takeAShit, _action_time, advanceGlobalTime)
