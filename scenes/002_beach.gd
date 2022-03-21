extends Node

func _init() -> void:
	State.changed_to.connect(_property_changed)

func _ready() -> void:
	_ready_deferred.call_deferred()

func _ready_deferred():
	$BeachNoon.set_current("beach_night" if State.beach_is_night else "beach_noon")

func _property_changed(property: String, value: Variant):
	match property:
		"beach_is_night": $BeachNoon.set_current("beach_night" if value else "beach_noon")
