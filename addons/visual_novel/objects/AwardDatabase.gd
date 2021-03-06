@tool
extends Database
class_name AwardDatabase
func get_class() -> String:
	return "AwardDatabase"

const MSG_AWARD_PROGRESS := "award_progress"
const MSG_AWARD_UNLOCKED := "award_unlocked"

signal unlocked(award: Award)
signal progress(award: Award)

func _get_data_class() -> String:
	return "Award"

func _post_init() -> void:
	super._post_init()
	Persistent.changed.connect(_changed)

func gain(id: String):
	var a: Award = find(id, "gain")
	if a:
		a.gain()

func _changed(property: Array):
	if property[0] == "awards" and has(property[1]):
		var a: Award = _all[property[1]]
		
		if a._unlocked:
			Global.notify({
				type=MSG_AWARD_UNLOCKED,
				text=[ "[yellow_green]Achieved[] %s" % a.name, a.desc ],
				play="award_got"
			})
			unlocked.emit(a)
		else:
			Global.notify({
				type=MSG_AWARD_PROGRESS,
				text=[ a.name, a.desc ],
				prog=a.get_progress(),
				play="award_progress"
			})
			progress.emit(a)
