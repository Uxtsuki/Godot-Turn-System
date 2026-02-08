extends Node
class_name StateMachine

@export var _timer : float = 0
@export var _time_limit : float = -1

@export var _current_state : State = null
@export var _current_states : Array[State] = []
@export var _state_queue : Array[State] = []

enum TYPE { SINGLE_STATE, STATE_QUEUE, MULTI_STATE}
@export var _type : TYPE = TYPE.SINGLE_STATE

@export var _is_queue_loop : bool = true

func _ready() -> void:
	if _time_limit != -1:
		_timer = _time_limit

func _switch_state(state : State = null) -> void:
	if _type != TYPE.SINGLE_STATE:
		return

	if _current_state && _current_state.is_processing():
		_current_state._stop()
	if state:
		_current_state = state
		_current_state._start()

func _switch(index : int = 0) -> void:
	if _state_queue.size() <= 0 || index > _state_queue.size() - 1:
		return
	var state : State = _state_queue.pop_at(index)

	match _type:
		TYPE.STATE_QUEUE:
			_current_state = state
			_current_state._start()
		_:
			state._start()
			_current_states.append(state)
	if _is_queue_loop:
		_state_queue.append(state)

func _populate(state : State) -> void:
	_state_queue.append(state)
	#if _type == TYPE.STATE_QUEUE && !state.is_connected("state_stopped", _switch):
	#	state.state_stopped.connect(_switch)

func _process(delta: float) -> void:
	if _time_limit != -1:
		if _timer > 0:
			_timer -= delta
		else:
			_timer = _time_limit
			if _type == TYPE.SINGLE_STATE:
				_switch_state()
			else:
				_switch()
