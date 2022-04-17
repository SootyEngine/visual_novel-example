@tool
extends Data
class_name Goal, "res://addons/visual_novel/icons/goal.png"
func get_class() -> String:
	return "Goal"

const MSG_STATE_CHANGED := "MSG_GOAL_STATE_CHANGED"

const GOAL_NOT_STARTED := "NOT_STARTED"
const GOAL_STARTED := "STARTED"
const GOAL_COMPLETED := "COMPLETED"
const GOAL_FAILED := "FAILED"
const GOAL_UNLOCKED := "UNLOCKED"

signal state_changed(goal: Goal)

var name := ""
var desc := ""
var main := true # main goal or a sub goal
var state := GOAL_NOT_STARTED:
	set(x):
		if state != x:
			state = x
			
			# broadcast state change, if main.
			if main:
				var msg := { text="[tomato]%s[]" % name }
				match state:
					GOAL_COMPLETED:
						msg.type = "goal_complete"
						Global.notify(msg)
					GOAL_STARTED:
						msg.type = "goal_started"
						Global.notify(msg)
				Global.message.emit(MSG_STATE_CHANGED, self)
			
			# alert.
			state_changed.emit(self)

var requires: Array[String] = [] # quests that need to be complete for this one to work.
var unlocks: Array[String] = [] # quests that will be unlcoekd when this one is complete.
var rewards: Array[String] = [] # rewards that will be unlocked.

func _post_init():
	super._post_init()
	for sub in get_required():
		sub.state_changed.connect(_sub_state_changed)

func _sub_state_changed(sub: Goal):
	if main:
		var msg := {
			text="[tomato]%s[]\n%s" % [name, sub.name],
			type="Goal Complete\n[hide].[]",
			prog=get_progress()
		}
		Global.notify(msg)
		Global.message.emit(MSG_STATE_CHANGED, self)
		if get_total_complete_required() >= get_total_required():
			complete()

func get_required() -> Array:
	return get_database().get_many(requires)

var is_completed: bool:
	get: return state == GOAL_COMPLETED

var is_started: bool:
	get: return state == GOAL_STARTED

var is_unlocked: bool:
	get: return state == GOAL_UNLOCKED

func get_total_required() -> int:
	return len(requires)

func get_total_complete_required() -> int:
	var out := 0
	for quest in get_required():
		if quest.is_completed:
			out += 1
	return out

func get_progress() -> float:
	var toll := get_total_required()
	var tick := get_total_complete_required()
	if tick == 0 or toll == 0:
		return 0.0
	return float(tick) / float(toll)

func has_requirements() -> bool:
	for sub in get_required():
		if not sub.is_completed:
			return false
	return true

func start(force := false):
	if force or has_requirements():
		state = GOAL_STARTED
	else:
		push_error("%s doesn't meet it's requirements." % self)

func complete():
	if state != GOAL_COMPLETED:
		state = GOAL_COMPLETED
