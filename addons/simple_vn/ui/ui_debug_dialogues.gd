extends Node

func _ready():
	_ready_deferred.call_deferred()

func _ready_deferred():
	var text := []
	var meta := {}
	for did in Dialogues.cache:
		var d: Dialogue = Dialogues.cache[did]
		text.append("[b]%s[]" % [did])
		for fid in d.flows:
			var flow := "%s.%s" % [did, fid]
			text.append("\t[meta %s]%s[]" % [flow, fid])
			meta[flow] = DialogueStack.goto.bind(flow, DialogueStack.STEP_GOTO)
	$RichTextLabel.set_bbcode("\n".join(text))
	$RichTextLabel._meta = meta
