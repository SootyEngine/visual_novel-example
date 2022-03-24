extends Node

func _init() -> void:
	add_to_group("sa:achieve")
	Persistent.changed.connect(_changed)

func _changed(property: String):
	var head := property.split(".", true, 1)[0]
	if head in self and self[head] is Achievement:
		var a: Achievement = self[head]
		print(a)
		if a._unlocked:
			Global.notify({
				type=Achievement.MSG_ACHIEVEMENT_UNLOCKED,
				text=[ "[yellow_green]Achieved[] %s" % a.name, a.desc ],
				play="achievement_got"
			})
			Global.message.emit(Achievement.MSG_ACHIEVEMENT_UNLOCKED, self)
		else:
			Global.notify({
				type=Achievement.MSG_ACHIEVEMENT_PROGRESS,
				text=[ a.name, a.desc ],
				prog=a._progress,
				play="achievement_progress"
			})
			Global.message.emit(Achievement.MSG_ACHIEVEMENT_PROGRESS, self)

func achieve(id: String):
	var prop := "a_%s" % id
	if State._has(prop) and State._get(prop) is Achievement:
		State._get(prop).unlock()
