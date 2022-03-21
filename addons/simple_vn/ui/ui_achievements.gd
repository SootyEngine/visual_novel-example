extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_ready_deferred.call_deferred()
	Global.message.connect(_global_message)

func _global_message(msg: String, payload: Variant):
	match msg:
		Achievement.MSG_ACHIEVEMENT_PROGRESS, Achievement.MSG_ACHIEVEMENT_UNLOCKED:
			_ready_deferred()

func _ready_deferred():
	print("Achievements updated")
	var achievements := Persistent._get_all_of_type(Achievement)
	var text := ["[center;i]ACHIEVEMENTS[]"]
	var meta := {}
	for id in achievements:
		var a: Achievement = achievements[id]
		var clr = Color.YELLOW_GREEN if a.unlocked else Color.TOMATO
		var id_unlock = "%s_unlock" % id
		var id_lock = "%s_lock" % id
		text.append("[%s]%s[] [dim][0.5]\\[%s\\][] [meta %s]UNLOCK[] [meta %s]LOCK[]" % [clr, a.name, a.unlocked, id_unlock, id_lock])
		meta[id_unlock] = a.unlock
		meta[id_lock] = a.lock
	$RichTextLabel.set_bbcode("\n".join(text))
	$RichTextLabel._meta = meta
