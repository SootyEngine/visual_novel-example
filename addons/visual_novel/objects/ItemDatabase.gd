@tool
extends Database
class_name ItemDatabase
func get_class():
	return "ItemDatabase"

func _get_data_class() -> String:
	return "Item"
