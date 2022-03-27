extends Node

@export var prefab: PackedScene
@export var wait := 0.0
@export var queue := []
@export var time_delay := 2.0

func _ready() -> void:
	$Button.pressed.connect(_ping)
	Global.message.connect(_global_message)

func _global_message(type, payload):
	if type == "notification":
		_ping(payload)

func _ping(msg := {text=["No Text Given", "Default Message"]}):
	queue.append(msg)

func _show(info: Dictionary):
	var n: Node = prefab.instantiate()
	$VBoxContainer.add_child(n)
	$VBoxContainer.move_child(n, 0)
	n.setup.call_deferred(info)

func _process(delta: float) -> void:
	if wait > 0.0:
		wait -= delta
	elif len(queue):
		_show(queue.pop_front())
		wait = time_delay
