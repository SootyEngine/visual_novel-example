extends Node

var music_volume := 1.0:
	set(v):
		music_volume = clampf(v, 0.0, 1.0)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(Music.BUS), linear2db(music_volume))

var music_mute := false:
	set(v):
		music_mute = v
		AudioServer.set_bus_mute(AudioServer.get_bus_index(Music.BUS), music_mute)

var sfx_volume := 1.0:
	set(v):
		sfx_volume = clampf(v, 0.0, 1.0)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(SFX.BUS), linear2db(sfx_volume))

var sfx_mute := false:
	set(v):
		sfx_mute = v
		AudioServer.set_bus_mute(AudioServer.get_bus_index(SFX.BUS), sfx_mute)
