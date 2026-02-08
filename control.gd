extends Control

var machine : StateMachine = StateMachine.new()
@export var m : State = State.new()

func _ready() -> void:
	machine._type = StateMachine.TYPE.SINGLE_STATE
	m._name = ";"
	#m._remaining = 3
	#m.state_stopped.connect(func():
	#	$Button.visible = false)
	#machine._timer = 2
	#machine._time_limit = 2
	#m._condition = _check

	machine.add_child(m)
	add_child(machine)
	#machine._switch_state(m)
	pass # Replace with function body.

func _on_button_pressed() -> void:
	machine._switch_state(m)

func _check() -> bool:
	return $CheckBox.button_pressed
