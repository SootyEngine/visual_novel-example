extends Data
class_name Award
func get_class() -> String:
	return "Award"

var name := ""
var desc := ""
var toll := 1
var hide := true
var icon := "res://icon.png"
var date := 0

var tick := 0:
	set(x):
		tick = clampi(x, 0, toll)
		if is_completed():
			date = DateTime.create_from_current().total_seconds

func is_unlocked() -> bool:
	return tick > 0

func is_completed() -> bool:
	return tick == toll

func complete() -> void:
	if not is_completed():
		tick = toll

func get_progress() -> float:
	return 0.0 if tick==0 or toll==0 else float(tick) / float(toll)
