extends DataManager
class_name Characters

# TODO: put this in a grammar class or something
var PRONOUNS := {
	they=	{m="he", 		s="she", 		n="they"},
	theyll=	{m="he'll", 	s="she'll", 	n="they'll"},
	theyd=	{m="he'd", 		s="she'd", 		n="they'd"},
	theyre=	{m="he's", 		s="she's", 		n="they're"},
	their=	{m="his", 		s="her", 		n="their"},
}

func _get_data_class() -> String:
	return "Character"
