@tool
extends Database
class_name GoalDatabase
func get_class() -> String:
	return "GoalDatabase"

func _get_data_class() -> String:
	return "Goal"
