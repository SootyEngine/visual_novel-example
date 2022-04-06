extends BaseDataClass
class_name Award

func get_class() -> String:
	return "Award"

var name := ""
var desc := ""
var toll := 1
var hide := true
var icon := "res://icon.png"
var date := -1

var _unlocked: bool = false:
	get: return tick == toll
	set(x):
		if _unlocked != x:
			self.tick = toll if x else 0

var _progress: float = 0.0:
	get: return 0.0 if tick==0 or toll==0 else float(tick) / float(toll)

var tick := 0:
	set(x):
		tick = clampi(x, 0, toll)
		if _unlocked:
			date = DateTime.create_from_current().total_seconds

func gain():
	_unlocked = true

func lose():
	_unlocked = false
