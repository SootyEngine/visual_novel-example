extends Node

func _ready():
	Mods.loaded.connect(_redraw)
	_redraw.call_deferred()

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
		text.append("[b;deep_sky_blue]%s[] [dim]by[] [i]%s[] [dim]([]v%s[dim]) [lb][]%s[dim][rb][]" % [mod.name, mod.author, mod.version, btn])
		if mod.installed:
			for k in mod.meta:
				if len(mod.meta[k]):
					text.append("\t%s" % k)
				for item in mod.meta[k]:
					text.append("\t\t[dim]%s[]" % item)
	$RichTextLabel.set_bbcode("\n".join(text))
	$RichTextLabel._meta = meta
