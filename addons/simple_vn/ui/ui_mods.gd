extends Node

func _init():
	Mods.loaded.connect(_redraw)

func _ready() -> void:
	_ready_deferred.call_deferred()

func _ready_deferred():
	_redraw()

func _redraw():
	var text := []
	var meta := {}
	text.append("USER MODS")
	for mod in Mods.get_installed() + Mods.get_uninstalled():
		var btn := ""
		if mod.installed:
			btn = "[meta %s;tomato]Uninstall[]" % [mod.dir]
			meta[mod.dir] = Mods.uninstall.bind(mod.dir)
		else:
			btn = "[meta %s;yellow_green]Install[]" % [mod.dir]
			meta[mod.dir] = Mods.install.bind(mod.dir)
		text.append("[b;deep_sky_blue]%s[] [dim]by[] [i]%s[] [dim]([]v%s[dim]) [lb][]%s[dim][rb][]" % [mod.name, mod.author, mod.version, btn])
	$RichTextLabel.set_bbcode("\n".join(text))
	$RichTextLabel._meta = meta
