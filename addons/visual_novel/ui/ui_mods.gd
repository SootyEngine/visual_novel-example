extends Node

func _ready():
	Mods.loaded.connect(_redraw)
	_redraw.call_deferred()

func _mod_type(dir: String):
	if dir == "res://":
		return "base"
	elif dir.begins_with("res://addons/"):
		return "addon"
	else:
		return "user"

func _redraw():
	var text := []
	var meta := {}
	for mod in Mods.get_installed() + Mods.get_uninstalled():
		var btn := ""
		if mod.installed:
			btn = "[meta %s;tomato]Uninstall[]" % [mod.dir]
			meta[mod.dir] = Mods.uninstall.bind(mod.dir)
		else:
			btn = "[meta %s;yellow_green]Install[]" % [mod.dir]
			meta[mod.dir] = Mods.install.bind(mod.dir)
		text.append("[dim;hint %s][%s][] [b;deep_sky_blue]%s[] [dim]by[] [i]%s[] [dim]([]v%s[dim]) [lb][]%s[dim][rb][]" % [mod.dir, _mod_type(mod.dir), mod.name, mod.author, mod.version, btn])
		if mod.installed:
			for k in mod.meta:
				if len(mod.meta[k]):
					text.append("\t%s" % k)
				for item in mod.meta[k]:
					var head = mod.dir.plus_file(k + "/")
					text.append("\t\t[dim]%s[]" % item.trim_prefix(head))
	$RichTextLabel.set_bbcode("\n".join(text))
	$RichTextLabel._meta = meta
