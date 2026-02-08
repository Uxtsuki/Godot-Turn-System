extends Node2D

var RNG : RandomNumberGenerator = RandomNumberGenerator.new()
var computer : StateMachine = StateMachine.new()
var player : StateMachine = StateMachine.new()

var _idle_state : State = State.new()
var _player_idle_state : State = State.new()
var _playing_state : State = State.new()
var _player_playing_state : State = State.new()

func _ready() -> void:
	_idle_state._name = "Computer Idle"
	_player_idle_state._name = "Player Idle"
	_playing_state._name = "Computer"
	_player_playing_state._name = "Player"

	player._type = StateMachine.TYPE.STATE_QUEUE
	computer._type = StateMachine.TYPE.STATE_QUEUE

	_idle_state._duration_time_limit = 5
	_idle_state.state_stopped.connect(func(): computer._switch())
	_playing_state._duration_time_limit = 5
	_playing_state.state_stopped.connect(func(): computer._switch())

	_player_idle_state._duration_time_limit = 5
	_player_idle_state.state_stopped.connect(func(): player._switch())
	_player_playing_state._duration_time_limit = 5 

	_player_playing_state.state_started.connect(
		func(): $CanvasLayer/ButtonChangeTurn.visible = true)
	_player_playing_state.state_stopped.connect(func(): 
		$CanvasLayer/ButtonChangeTurn.visible = false
		player._switch())
	
	add_child(computer)
	computer.add_child(_playing_state)
	computer.add_child(_idle_state)
	add_child(player)
	player.add_child(_player_playing_state)
	player.add_child(_player_idle_state)

	if RNG.randf() > 0.5:
		player._populate(_player_playing_state)
		player._populate(_player_idle_state)
		computer._populate(_idle_state)
		computer._populate(_playing_state)
	else:
		computer._populate(_playing_state)
		computer._populate(_idle_state)
		player._populate(_player_idle_state)
		player._populate(_player_playing_state)
	_change_turn()

func _change_turn() -> void:
	if !computer._current_state && !player._current_state:
		computer._switch()
		player._switch()
	else:
		computer._current_state._duration_timer = 0
		player._current_state._duration_timer = 0

func _process(delta: float) -> void:
	if computer && computer._current_state:
		$CanvasLayer/Label.text = computer._current_state._name + str(computer._current_state._duration_timer)

	if player && player._current_state:
		$CanvasLayer/Label2.text = player._current_state._name + str(player._current_state._duration_timer)
