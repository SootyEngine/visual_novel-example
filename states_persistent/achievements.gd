extends Node

var a_started := Achievement.new({name="Started", desc="Started the Quest."})
var a_first_quest := Achievement.new({name="First Quest", desc="Beat the first Quest."})

var a_multi := Achievement.new({name="Defeat 3 Drain-Dragons", desc="Sharpen those fists and kill 3 dracos.", toll=3})

func _init() -> void:
	add_to_group("sa:achieve")
	Persistent.changed.connect(_changed)

func _changed(property: String):
	var head := property.split(".", true, 1)[0]
	if head in self and self[head] is Achievement:
		var a: Achievement = self[head]
		if a._unlocked:
			Global.notify({
				type=Achievement.MSG_ACHIEVEMENT_UNLOCKED,
				text=[ "[yellow_green]Achieved[] %s" % a.name, a.desc ]
			})
			Global.message.emit(Achievement.MSG_ACHIEVEMENT_UNLOCKED, self)
		else:
			Global.notify({
				type=Achievement.MSG_ACHIEVEMENT_PROGRESS,
				text=[ a.name, a.desc ],
				prog=a._progress
			})
			Global.message.emit(Achievement.MSG_ACHIEVEMENT_PROGRESS, self)

func achieve(id: String):
	var prop := "a_%s" % id
	if State._has(prop) and State._get(prop) is Achievement:
		State._get(prop).unlock()
