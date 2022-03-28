extends Node

@export var _task_list: NodePath
@export var _task_info: NodePath
@export var _subtask_list: NodePath
@onready var task_list: RichTextLabel2 = get_node(_task_list)
@onready var task_info: RichTextLabel2 = get_node(_task_info)
@onready var subtask_list: RichTextLabel2 = get_node(_subtask_list)

func _ready():
	Global.message.connect(_global_message)
	_ready_deferred.call_deferred()

func _global_message(msg: String, payload: Variant):
	match msg:
		Task.MSG_STATE_CHANGED:
			_ready_deferred()

func _ready_deferred():
	var all_tasks = Task.get_all().values()
	var s_started = all_tasks.filter(func(x): return not x.goal and x.is_started)
	var s_completed = all_tasks.filter(func(x): return not x.goal and x.is_completed)
	var s_unlocked = all_tasks.filter(func(x): return not x.goal and x.is_unlocked)
	var s_other = all_tasks.filter(func(x): return not not x.goal or (not x.is_started and not x.is_completed and not x.is_unlocked))
	
	var text := ["[center;i]QUESTS[]"]
	for part in [
		{text="▶ [deep_sky_blue;b]Started[]", list=s_started},
		{text="▶ [yellow_green;b]Completed[]", list=s_completed},
		{text="▶ [dark_gray;b]Unlocked[]", list=s_unlocked},
		{text="▶ [tomato;b]Debug[]", list=s_other}
	]:
		text.append(part.text)
		for quest in part.list:
			var tick = quest.get_total_complete_required()
			var toll = quest.get_total_required()
			if toll > 0:
				text.append("\t%s \\[%s/%s\\] [dim]%s[]" % [quest.name, tick, toll, quest.state])
				for subquest in quest.get_required():
					text.append("\t\t- %s [dim]%s[]" % [subquest.name, subquest.state])
			else:
				text.append("\t%s [dim]%s[]" % [quest.name, quest.state])
	
	task_list.set_bbcode("\n".join(text))
