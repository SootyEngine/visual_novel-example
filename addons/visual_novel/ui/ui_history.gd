extends Node

func _ready() -> void:
	$Node.changed.connect(_redraw)
	$VBoxContainer/show_state_changes.pressed.connect(_redraw)

func _redraw():
	var text = []
	var show_state = $VBoxContainer/show_state_changes.button_pressed
	var index := 1
	for i in len($Node.steps):
		if $Node.steps[i].type == 2 and not show_state:
			continue
		text.append($Node._formatted(i))
		index += 1
	$VBoxContainer/RichTextLabel.set_bbcode("\n".join(text))

