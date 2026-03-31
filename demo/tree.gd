@tool
extends Tree


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = create_item()
	hide_root = true
	var item = create_item(root)
	item.set_text(0, "item")
	var editable_item = create_item(root)
	editable_item.set_text(0, "Editable Item")
	editable_item.set_editable(0, true)
	var subtree = create_item(root)
	subtree.set_text(0, "Subtree")
	var check_item = create_item(subtree)
	check_item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
	check_item.set_editable(0, true)
	check_item.set_text(0, "Check Item")
