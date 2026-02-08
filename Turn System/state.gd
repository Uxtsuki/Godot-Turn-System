extends Node
class_name State

signal state_started
signal state_stopped

@export var _name : String = ""
@export var _condition : Callable = Callable()

@export var _remaining : int = -1
@export var _duration_timer : float = 0
@export var _duration_time_limit : float = -1

func _ready() -> void:
	set_physics_process(false)
	set_process(false)

func _start() -> void:
	if _remaining != -1:
		if _remaining <= 0:
			return
		else:
			_remaining -= 1
	print("Starting ", _name)
	state_started.emit()
	set_physics_process(true)
	set_process(true)
	if _duration_time_limit != -1:
		_duration_timer = _duration_time_limit

func _process(delta: float) -> void:
	if _duration_time_limit != -1:
		if _duration_timer > 0:
			_duration_timer -= delta
		elif is_processing():
			_stop()
	if _condition:
		var result : bool = _condition.call()
		if result && !is_processing():
			_start()
		elif !result && is_processing():
			_stop()

func _stop() -> void:
	print("Stopping ", _name)
	state_stopped.emit()
	set_physics_process(false)
	set_process(false)
