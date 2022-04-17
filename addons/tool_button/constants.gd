extends RefCounted
class_name ToolButton

enum Action {
	SCAN, # scans file system after buttons function is called
	EDIT_FILE, # selects and edits a file
	SELECT_FILE, # selects and edits a file
	EDIT_RESOURCE, # selects and edits a resource
}
