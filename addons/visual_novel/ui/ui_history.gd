extends Node

func _ready() -> void:
	$Node.changed.connect(_redraw)

func _redraw():
	var text = []
	for i in len($Node.steps):
		text.append("%s) %s" % [i, $Node._formatted(i)])
	$RichTextLabel.set_bbcode("\n".join(text))

