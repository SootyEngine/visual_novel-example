@tool
extends Database
class_name InventoryDatabase, "res://addons/visual_novel/icons/inventory.png"
func get_class() -> String:
	return "InventoryDatabase"

func _get_data_class() -> String:
	return "Inventory"
