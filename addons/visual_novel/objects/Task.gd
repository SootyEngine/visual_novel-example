extends BaseDataClass
class_name Task

func get_class() -> String:
	return "Task"

const MSG_STATE_CHANGED := "MSG_TASK_STATE_CHANGED"

const TASK_NOT_STARTED := "NOT_STARTED"
const TASK_STARTED := "STARTED"
const TASK_COMPLETED := "COMPLETED"
const TASK_FAILED := "FAILED"
const TASK_UNLOCKED := "UNLOCKED"

signal state_changed(task: Task)

var name := ""
var desc := ""
var goal := false
var state := TASK_NOT_STARTED:
	set(x):
		if state != x:
			state = x
			
			# broadcast state change, if main.
			if not goal:
				var msg := { text="[tomato]%s[]" % name }
				match state:
					TASK_COMPLETED:
						msg.type = "task_complete"
						Global.notify(msg)
					TASK_STARTED:
						msg.type = "task_started"
						Global.notify(msg)
				Global.message.emit(MSG_STATE_CHANGED, self)
			
			# alert.
			state_changed.emit(self)

var requires: Array[String] = [] # quests that need to be complete for this one to work.
var unlocks: Array[String] = [] # quests that will be unlcoekd when this one is complete.
var rewards: Array[String] = [] # rewards that will be unlocked.

func _post_init():
	super._post_init()
	for task in get_required():
		task.state_changed.connect(_subtask_state_changed)

func _subtask_state_changed(subtask: Task):
	prints(self, goal, "SUBQUEST CHANGED", subtask)
	
	if not goal:
		var msg := {
			text="[tomato]%s[]\n%s" % [name, subtask.name],
			type="Goal Complete\n[hide].[]",
			prog=get_progress()
		}
		Global.notify(msg)
		Global.message.emit(MSG_STATE_CHANGED, self)
		if get_total_complete_required() >= get_total_required():
			complete()

func get_required() -> Array[Task]:
	var all := State._get_all_of_type(Task)
	var out := []
	for k in requires:
		if k in all:
			out.append(all[k])
		else:
			push_error("No quest %s. %s" % [k, all])
	return out

var is_completed: bool:
	get: return state == TASK_COMPLETED

var is_started: bool:
	get: return state == TASK_STARTED

var is_unlocked: bool:
	get: return state == TASK_UNLOCKED

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
	for task in get_required():
		if not task.is_completed:
			return false
	return true

func start(force := false):
	if force or has_requirements():
		state = TASK_STARTED
	else:
		push_error("%s doesn't meet it's requirements." % self)

func complete():
	if state != TASK_COMPLETED:
		state = TASK_COMPLETED

static func exists(id: String) -> bool:
	return State._has_of_type(id, Task)

static func get_all() -> Dictionary:
	return State._get_all_of_type(Task)
