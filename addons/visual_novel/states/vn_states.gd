@tool
extends Node

# databases
var data := Database.new() # unorganized data
var inventories := InventoryDatabase.new()
var items := ItemDatabase.new()
var characters := CharacterDatabase.new()
var goals := GoalDatabase.new()
var locations := LocationDatabase.new()
var equipment_slots := EquipmentSlotDatabase.new()

# flow state
var flow_history := []
var flow_visited := {}
var choice_history := {}

# captions
var caption_at := "bottom"
var caption_auto_clear := true

# common
var time := DateTime.new({weekday="sat"})
var score := 0

const F_GAME_STARTED := "_main/game_started"
const F_DIALOGUE_ENDED := "_main/dialogue_ended"
const F_FLOW_ENDED := "_main/flow_ended"

func _ready() -> void:
	Global.started.connect(_game_started)
	Dialogue.started.connect(_dialogue_started)
	Dialogue.ended.connect(_dialogue_ended)
	Dialogue.flow_started.connect(_flow_started)
	Dialogue.flow_ended.connect(_flow_ended)
	Dialogue.selected.connect(_selected)

func _game_started():
	if Dialogue.has_path(F_GAME_STARTED):
		Dialogue.goto(F_GAME_STARTED)
	else:
		push_error("There is no '%s' flow." % F_GAME_STARTED)

func _selected(id: String):
	UDict.tick(choice_history, id)

func _dialogue_started():
	flow_history.clear()

func _dialogue_ended():
	if len(flow_history) and flow_history[-1] != F_DIALOGUE_ENDED and Dialogue.has_path(F_DIALOGUE_ENDED):
		Dialogue.stack(F_DIALOGUE_ENDED)

func _flow_started(flow: String):
	flow_history.append(flow)

func _flow_ended(flow: String):
	# tick number of times visited
	UDict.tick(flow_visited, flow)
	# goto the ending node
	if len(flow_history) and not flow_history[-1] in [F_DIALOGUE_ENDED, F_FLOW_ENDED] and Dialogue.has_path(F_FLOW_ENDED):
		Dialogue.stack(F_FLOW_ENDED)

# output a property in a formatted way
func show(property: String) -> String:
	# TODO: format
	return "[b]%s[]" % State._get(property)

# the current location
func location() -> String:
	return VisualNovel.scene.scene_id if VisualNovel.scene else ""
	
#func caption(kwargs: Dictionary):
#	if "at" in kwargs:
#		State._set("caption_at", kwargs.at)
#	if "clear" in kwargs:
#		State._set("caption_auto_clear", kwargs.clear)

func stutter(x: String) -> String:
	var parts := x.split(" ")
	for i in len(parts):
		if len(parts[i]) > 2:
			parts[i] = parts[i].substr(0, 1 if randf()>.5 else 2) + "-" + parts[i].to_lower()
	return " ".join(parts)

func commas(x: String) -> String:
	return UString.commas(UObject.get_operator_value(x))

func humanize(x: String) -> String:
	return UString.humanize(UObject.get_operator_value(x))

func plural(x: String, one := "%s", more := "%s's", none := "%s's") -> String:
	return UString.plural(UObject.get_operator_value(x), one, more, none)

func ordinal(x: String) -> String:
	return UString.ordinal(UObject.get_operator_value(x))

func capitalize(x: String) -> String:
	return str(x).capitalize()

func lowercase(x: String) -> String:
	return str(x).to_lower()

func uppercase(x: String) -> String:
	return str(x).to_upper()

# Cache the pick function so it doesn't give the same option too often.
# Still random, just not as boring.
var _pick_cache := {}
func pick(x: Variant):
	# if a dictionary? treat as weighted dict
	if x is Dictionary:
		return URand.pick_weighted(x)
	
	# cache a duplicate to be randomly picked from
	if not x in _pick_cache:
		_pick_cache[x] = x.duplicate()
		_pick_cache[x].shuffle()
	
	var got = _pick_cache[x].pop_back()
	
	if len(_pick_cache[x]) == 0:
		_pick_cache[x] = x.duplicate()
		_pick_cache[x].shuffle()
	
	return got

func test(s: Variant, ontrue := "yes", onfalse := "no"):
	return ontrue if s else onfalse
