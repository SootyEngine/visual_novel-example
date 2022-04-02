extends Node

const MAX_STEPS := 1_000

signal changed()

var max_steps := 100
var steps := []

enum { STEP_TEXT, STEP_CHOICE, STEP_STATE }

func _ready() -> void:
	DialogueStack.on_line.connect(_on_line)
	DialogueStack.option_selected.connect(_option_selected)
	State.changed_from_to.connect(_changed_from_to)
	
func _on_line(line: DialogueLine):
	_push_step({
		type=STEP_TEXT,
		from=line.from,
		text=line.text
	})

func _option_selected(option: DialogueLine):
	_push_step({
		type=STEP_CHOICE,
		text=option.text
	})

func _changed_from_to(prop, from, to):
	_push_step({
		type=STEP_STATE,
		prop=prop,
		from=from,
		to=to
	})

func _push_step(step: Dictionary):
	if len(steps) >= mini(max_steps, MAX_STEPS):
		steps.pop_front()
	steps.push_back(step)
	changed.emit()

func _formatted(i: int) -> String:
	var step: Dictionary = steps[i]
	match step.type:
		STEP_TEXT:
			if step.from != null:
				return "[b]%s[] \"%s\"" % [step.from, RichTextLabel2.sanitize(step.text)]
			else:
				return RichTextLabel2.sanitize(step.text)
		
		STEP_CHOICE:
			return "[tomato]< []%s[tomato] >[]" % RichTextLabel2.sanitize(step.text)
		
		STEP_STATE:
			return "Set [green_yellow]%s[] to [yellow_green]%s[]. (Was [yellow_green]%s[].)" % [step.prop, step.to, step.from]
		
		_:
			return ""
