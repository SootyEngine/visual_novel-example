@tool
extends RefCounted
class_name Grammar

var pronouns := {
	they=	{m="he", 		s="she", 		n="they"},
	theyll=	{m="he'll", 	s="she'll", 	n="they'll"},
	theyd=	{m="he'd", 		s="she'd", 		n="they'd"},
	theyre=	{m="he's", 		s="she's", 		n="they're"},
	their=	{m="his", 		s="her", 		n="their"},
	them=	{m="him",		s="her",		n="them"},
}

func get_pronoun(id: String, gender: String) -> String:
	var lower := id.to_lower()
	if lower in pronouns:
		if gender in pronouns[lower]:
			if UString.is_capitalized(id):
				return pronouns[lower][gender].capitalized()
			else:
				return pronouns[lower][gender]
	return id
