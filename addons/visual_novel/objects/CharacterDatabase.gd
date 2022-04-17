@tool
extends Database
class_name CharacterDatabase, "res://addons/visual_novel/icons/people.png"
func get_class() -> String:
	return "CharacterDatabase"

func _get_data_class() -> String:
	return "Character"
