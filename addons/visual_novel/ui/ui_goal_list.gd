extends Node

@export var _list: NodePath
@export var _info: NodePath
@export var _subtask_list: NodePath
@onready var list: RichTextLabel2 = get_node(_list)
@onready var info: RichTextLabel2 = get_node(_info)
@onready var subtask_list: RichTextLabel2 = get_node(_subtask_list)

func _ready():
	Global.message.connect(_global_message)
	_ready_deferred.call_deferred()

func _global_message(msg: String, payload: Variant):
	match msg:
		Goal.MSG_STATE_CHANGED:
			_ready_deferred()

func _ready_deferred():
	var all := Goal.get_all().values()
	var s_started := all.filter(func(x): return x.main and x.is_started)
	var s_completed := all.filter(func(x): return x.main and x.is_completed)
	var s_unlocked := all.filter(func(x): return x.main and x.is_unlocked)
	var s_other := all.filter(func(x): return not x.main or (not x.is_started and not x.is_completed and not x.is_unlocked))
	
	var text := ["[center;i]ALL[]"]
	for part in [
		{text="▶ [deep_sky_blue;b]Started[]", list=s_started},
		{text="▶ [yellow_green;b]Completed[]", list=s_completed},
		{text="▶ [dark_gray;b]Unlocked[]", list=s_unlocked},
		{text="▶ [tomato;b]Debug[]", list=s_other}
	]:
		text.append(part.text)
		for item in part.list:
			var tick = item.get_total_complete_required()
			var toll = item.get_total_required()
			if toll > 0:
				text.append("\t%s \\[%s/%s\\] [dim]%s[]" % [item.name, tick, toll, item.state])
				for sub in item.get_required():
					text.append("\t\t- %s [dim]%s[]" % [sub.name, sub.state])
			else:
				text.append("\t%s [dim]%s[]" % [item.name, item.state])
	
	list.set_bbcode("\n".join(text))
