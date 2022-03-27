extends Node

# call a method for all groups
func all(group: String, method: String, args: Array):
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, group, method, args)

func commas(x):
	return UString.commas(UObject.get_operator_value(x))

func humanize(x):
	return UString.humanize(UObject.get_operator_value(x))

func plural(x, one:="%s", more:="%s's", none:="%s's"):
	return UString.plural(UObject.get_operator_value(x), one, more, none)

func ordinal(x):
	return UString.ordinal(UObject.get_operator_value(x))

func capitalize(x):
	return str(x).capitalize()

func lowercase(x):
	return str(x).to_lower()

func uppercase(x):
	return str(x).to_upper()

# Cache the pick function so it doesn't give the same option too often.
# Still random, just not as boring.
var _pick_cache := {}
func pick(x):
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

func stutter(x):
	var parts := str(x).split(" ")
	for i in len(parts):
		if len(parts[i]) > 2:
			parts[i] = parts[i].substr(0, 1 if randf()>.5 else 2) + "-" + parts[i].to_lower()
	return " ".join(parts)
