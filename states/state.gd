@tool
extends Node

#var awards := AwardManager.new()
var items: ItemManager = ItemManager.new()
var equipment_slots := EquipmentSlotManager.new()
var characters := CharacterManager.new({
	godot = Character.new({name="Godot", color=Color.DEEP_SKY_BLUE}),
	godette = {name="Godette", color=Color.SKY_BLUE},
	godot_game_engine = Character.new({name="Godot Game Engine", color=Color.DEEP_SKY_BLUE}),
	sooty = Character.new({name="Sooty", color=Color.DARK_GRAY}),
	mr_bool = Character.new({name="Mr. Bool", color=Color.BURLYWOOD}),
	chris = Character.new({name="Chris", color=Color.DEEP_SKY_BLUE}),
	paul = {
		name="Paul",
		color=Color.GREEN_YELLOW,
		items=Inventory.new()
	},
	john = Character.new({name="John", color=Color.TOMATO})
})

var areas := LocationManager.new({
	zone = Location.new({name="The Zone", color=Color.TEAL})
})

var beach_is_night := false
var save_caption := "The Quest"

var score := 0




#func _init() -> void:
#	Saver._get_state_info.connect(_get_state_info)
#
#func _get_state_info(d: Dictionary):
#	d.caption = save_caption
