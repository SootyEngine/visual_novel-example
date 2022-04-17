@tool
extends Database
class_name LocationDatabase, "res://addons/visual_novel/icons/locations.png"
func get_class():
	return "LocationDatabase"

func _get_data_class():
	return "Location"
