extends Node

@export var _prefab: NodePath
@export var _parent: NodePath
@onready var prefab: Node = get_node(_prefab)
@onready var parent: Node = get_node(_parent)

func _ready() -> void:
	parent.remove_child(prefab)
	
	await get_tree().process_frame
	ModManager.loaded.connect(_connect)

func _connect():
	var awards: AwardDatabase = Database.get_database(Award)
	awards.unlocked.connect(_update)
	awards.progress.connect(_update)
	_update()

func _update(_x=null):
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()
	
	var awards: AwardDatabase = Database.get_database(Award)
	for award in awards:
		var id = award.get_id()
		var btn = prefab.duplicate()
		parent.add_child(btn)
		btn.get_child(0)._setup(award)
		btn.get_child(1).pressed.connect(Persistent._set.bind("awards.%s.tick"%id, award.tick-1))
		btn.get_child(2).pressed.connect(Persistent._set.bind("awards.%s.tick"%id, award.tick+1))

