@tool
extends Database
class_name EquipmentSlotDatabase
func get_class() -> String:
	return "EqupmentSlotDatabase"

func _get_data_class() -> String:
	return "EquipmentSlot"
