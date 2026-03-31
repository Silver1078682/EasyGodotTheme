@tool
class_name EasyTheme
extends Theme

@export_group("Spacing")
## Spacing width, affecting [BoxContainer] and [MarginContainer].
## lower value means more compact layout.
@export var spacing_width := -1
## if the [member spacing_width] will also be applied to [PopupMenu] and [PopupPanel]
@export var spacing_affect_popup := false

@export_group("Color", COLOR_PREFIX)
const COLOR_PREFIX := "color_"
const COLOR_FALLBACK := Color.GRAY
@export var color_normal := Color.WEB_GRAY
@export var color_hover := Color("505050ff")
@export var color_pressed := Color("505050ff")
@export var color_hover_pressed := Color("505050ff")
@export var color_disabled := Color("3a3a3aff")
@export var color_focus := Color("#6495ed")
@export var color_panel := Color("#272727")
## If we should also apply the corresponding color to the border of a StyleBoxFlat
## ignored if you are not using a StyleBoxFlat at all
@export var color_applied_to_border := true
@export_group("Font Color", FONT_COLOR_PREFIX)
const FONT_COLOR_PREFIX := "font_color_"
const FONT_COLOR_FALLBACK := Color.GRAY
@export var font_color_normal := Color.WHITE
@export var font_color_hover := Color.WHITE
@export var font_color_pressed := Color.WHITE
@export var font_color_hover_pressed := Color.WHITE
@export var font_color_disabled := Color.GRAY
@export var font_color_focus := Color.WHITE


@export_group("Style Box", STYLE_BOX_PREFIX)
const STYLE_BOX_PREFIX := "stylebox_"
static var STYLE_BOX_FALLBACK := StyleBoxFlat.new()
@export var stylebox_default: StyleBox
@export_subgroup("Non Default", "stylebox_")
@export var stylebox_normal: StyleBox
@export var stylebox_hover: StyleBox
@export var stylebox_pressed: StyleBox
@export var stylebox_hover_pressed: StyleBox
@export var stylebox_disabled: StyleBox
@export var stylebox_focus: StyleBox
@export var stylebox_panel: StyleBox

@export_group("Generate")
@export_subgroup("Button", "button_")
## [Button] and its inheritors
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var button_should_generate := true
@export var button_override_enabled := false:
	set(p_value):
		button_override_enabled = p_value
		notify_property_list_changed()

const BUTTON_OVERRIDE_PREFIX := "button_override_"
@export var button_override_stylebox_default: StyleBox
@export var button_override_stylebox_normal: StyleBox
@export var button_override_stylebox_hover: StyleBox
@export var button_override_stylebox_pressed: StyleBox
@export var button_override_stylebox_hover_pressed: StyleBox
@export var button_override_stylebox_disabled: StyleBox
@export var button_override_stylebox_focus: StyleBox

@export_subgroup("TextField", "text_field_")
## [LineEdit] and [CodeEdit]
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var text_field_should_generate := true
@export var text_field_caret_width := 2
@export var text_field_caret_color := Color.WHITE
@export var text_field_selection_color := Color(Color.BLACK, 0.1)

@export_subgroup("Slider", "slider_")
## [HSlider]/[VSlider] [HScrollBar]/[VScrollBar] [ProgressBar]
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var slider_should_generate := true
@export var slider_thickness := 5

@export_subgroup("TabBar", "tab_bar_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var tab_bar_should_generate := true

@export_subgroup("Popup", "popup_")
const POPUP_OVERRIDE_PREFIX = "popup_override_"
## [PopUpMenu] [PopUpPanel]
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var popup_should_generate := true
@export var popup_override_enabled := false:
	set(p_value):
		popup_override_enabled = p_value
		notify_property_list_changed()
@export var popup_override_stylebox_normal: StyleBox
@export var popup_override_stylebox_hover: StyleBox
@export var popup_override_color_normal := Color.DARK_GRAY
@export var popup_override_color_hover := Color.GRAY

@export_subgroup("Tree", "tree_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var tree_should_generate := true
@export_subgroup("Foldable", "foldable_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var foldable_should_generate := true

@export_group("Action")
@export_tool_button("Generate Theme") var _generate_button := _generate
## Clear the theme properties. This won't affect the EasyTheme stuffs 
@export_tool_button("Clear Theme") var _clear_button := clear
## Save as an ordinary [Theme].
@export_tool_button("Save as Common") var _save_as_theme_button := _save_as_theme

const TYPES := [
		"normal",
		"hover",
		"pressed",
		"hover_pressed",
		"disabled",
		"focus",
		"panel",
	]


#region Main Logic
func _generate() -> void:
	_generate_styleboxes()
	_apply_theme()

func _apply_theme():
	# Sometimes the editor just freeze for a period of time when applying the theme (idk why)
	# This rarely happens, but in case we will pause the progress once in a while
	var donot_block := EditorInterface.get_base_control().get_tree().process_frame

	if button_should_generate:
		set_stylebox(&"normal", &"Button", _button_override_styleboxes["normal"])
		set_stylebox(&"hover", &"Button", _button_override_styleboxes["hover"])
		set_stylebox(&"pressed", &"Button", _button_override_styleboxes["pressed"])
		set_stylebox(&"hover_pressed", &"Button", _button_override_styleboxes["hover_pressed"])
		set_stylebox(&"focus", &"Button", _button_override_styleboxes["focus"])
		set_stylebox(&"disabled", &"Button", _button_override_styleboxes["disabled"])
		set_color(&"font_color", &"Button", font_color_normal)
		set_color(&"font_hover_color", &"Button", font_color_normal)
		set_color(&"font_pressed_color", &"Button", font_color_pressed)
		set_color(&"font_hover_pressed_color", &"Button", font_color_hover_pressed)
		set_color(&"font_disabled_color", &"Button", font_color_disabled)
		await donot_block
		
		
		set_stylebox(&"normal", &"MenuBar", _button_override_styleboxes["normal"])
		set_stylebox(&"hover", &"MenuBar", _button_override_styleboxes["hover"])
		set_stylebox(&"pressed", &"MenuBar", _button_override_styleboxes["pressed"])
		set_stylebox(&"hover_pressed", &"MenuBar", _button_override_styleboxes["hover_pressed"])
		set_stylebox(&"focus", &"MenuBar", _button_override_styleboxes["focus"])
		set_stylebox(&"disabled", &"MenuBar", _button_override_styleboxes["disabled"])
		await donot_block

		set_color(&"checkbox_checked_color", &"CheckBox", color_pressed)
		set_color(&"checkbox_unchecked_color", &"CheckBox", color_disabled)
		set_color(&"button_checked_color", &"CheckButton", color_pressed)
		set_color(&"button_unchecked_color", &"CheckButton", color_disabled)
		await donot_block

	if text_field_should_generate:
		set_stylebox(&"normal", &"LineEdit", _styleboxes["normal"])
		set_stylebox(&"read_only", &"LineEdit", _styleboxes["disabled"])
		set_stylebox(&"focus", &"LineEdit", _styleboxes["focus"])
		
		set_stylebox(&"normal", &"TextEdit", _styleboxes["normal"])
		set_stylebox(&"read_only", &"TextEdit", _styleboxes["disabled"])
		set_stylebox(&"focus", &"TextEdit", _styleboxes["focus"])
		await donot_block
		

		set_constant(&"caret_width", &"LineEdit", text_field_caret_width)
		set_constant(&"caret_width", &"TextEdit", text_field_caret_width)
		set_color(&"caret_color", &"LineEdit", text_field_caret_color)
		set_color(&"caret_color", &"TextEdit", text_field_caret_color)
		set_color(&"selection_color", &"LineEdit", text_field_selection_color)
		set_color(&"selection_color", &"TextEdit", text_field_selection_color)
		await donot_block

	if slider_should_generate:
		var h_stylebox := _styleboxes["disabled"].duplicate()
		var v_stylebox := h_stylebox.duplicate()
		if h_stylebox is StyleBoxFlat:
			h_stylebox.border_width_top = slider_thickness
			h_stylebox.border_width_bottom = slider_thickness
			v_stylebox.border_width_left = slider_thickness
			v_stylebox.border_width_right = slider_thickness

		set_stylebox(&"grabber_area", &"HSlider", _styleboxes["normal"])
		set_stylebox(&"grabber_area_highlight", &"HSlider", _styleboxes["hover"])
		set_stylebox(&"slider", &"HSlider", h_stylebox)
		set_stylebox(&"grabber_area", &"VSlider", _styleboxes["normal"])
		set_stylebox(&"grabber_area_highlight", &"VSlider", _styleboxes["hover"])
		set_stylebox(&"slider", &"VSlider", v_stylebox)
		await donot_block

		set_stylebox(&"grabber", &"HScrollBar", _styleboxes["normal"])
		set_stylebox(&"grabber_highlight", &"HScrollBar", _styleboxes["hover"])
		set_stylebox(&"grabber_pressed", &"HScrollBar", _styleboxes["pressed"])
		set_stylebox(&"scroll", &"HScrollBar", h_stylebox)
		set_stylebox(&"grabber", &"VScrollBar", _styleboxes["normal"])
		set_stylebox(&"grabber_highlight", &"VScrollBar", _styleboxes["hover"])
		set_stylebox(&"grabber_pressed", &"VScrollBar", _styleboxes["pressed"])
		set_stylebox(&"scroll", &"VScrollBar", v_stylebox)

		set_stylebox(&"fill", &"ProgressBar", _styleboxes["normal"])
		set_stylebox(&"background", &"ProgressBar", _styleboxes["disabled"])
		await donot_block
		
	
	if tab_bar_should_generate:
		set_stylebox(&"tab_unselected", &"TabContainer", _styleboxes["normal"])
		set_stylebox(&"tab_hovered", &"TabContainer", _styleboxes["hover"])
		set_stylebox(&"tab_selected", &"TabContainer", _styleboxes["pressed"])
		set_stylebox(&"tab_disabled", &"TabContainer", _styleboxes["disabled"])
		set_stylebox(&"tab_hovered", &"TabContainer", _styleboxes["hover"])
		set_stylebox(&"panel", &"TabContainer", _styleboxes["disabled"])
		await donot_block

	if popup_should_generate:
		set_stylebox(&"panel", &"PopupMenu", _popup_override_styleboxes["normal"])
		set_stylebox(&"hover", &"PopupMenu", _popup_override_styleboxes["hover"])
		set_stylebox(&"panel", &"PopupPanel", _popup_override_styleboxes["normal"])
		set_stylebox(&"hover", &"PopupPanel", _popup_override_styleboxes["hover"])
		await donot_block
	
	if tree_should_generate:
		set_stylebox(&"panel", &"Tree", _styleboxes["disabled"])
		set_stylebox(&"hovered", &"Tree", _styleboxes["hover"])
		set_stylebox(&"selected", &"Tree", _styleboxes["pressed"])
		set_stylebox(&"hovered_selected", &"Tree", _styleboxes["hover_pressed"])
		set_stylebox(&"button_hover", &"Tree", _styleboxes["hover"])
		set_stylebox(&"button_pressed", &"Tree", _styleboxes["pressed"])
		await donot_block
	
	if foldable_should_generate:
		set_stylebox(&"title_panel", &"FoldableContainer", _styleboxes["normal"])
		set_stylebox(&"title_collapsed_panel", &"FoldableContainer", _styleboxes["normal"])
		set_stylebox(&"title_hover_panel", &"FoldableContainer", _styleboxes["hover"])
		set_stylebox(&"title_collapsed_hover_panel", &"FoldableContainer", _styleboxes["hover"])
		set_stylebox(&"panel", &"FoldableContainer", _styleboxes["disabled"])
		set_stylebox(&"focus", &"FoldableContainer", _styleboxes["focus"])
		await donot_block

	if spacing_width != -1:
		set_constant(&"separation", &"VBoxContainer", spacing_width)
		set_constant(&"separation", &"HBoxContainer", spacing_width)
		set_constant(&"margin_left", &"MarginContainer", spacing_width)
		set_constant(&"margin_right", &"MarginContainer", spacing_width)
		set_constant(&"margin_top", &"MarginContainer", spacing_width)
		set_constant(&"margin_bottom", &"MarginContainer", spacing_width)
		if spacing_affect_popup:
			set_constant(&"v_separation", &"PopupMenu", spacing_width)
			set_constant(&"h_separation", &"PopupMenu", spacing_width)
		await donot_block

	set_color(&"font_color",&"Label", font_color_normal)
	set_stylebox(&"panel", &"Panel", _styleboxes["panel"])
	set_stylebox(&"panel", &"PanelContainer", _styleboxes["panel"])
	

#endregion

#region stylebox
var _styleboxes: Dictionary[String, StyleBox] = {}


func _generate_styleboxes() -> void:
	_styleboxes.clear()
	_popup_override_styleboxes = _styleboxes.duplicate()
	_button_override_styleboxes = _styleboxes.duplicate()
	for type in TYPES:
		_styleboxes[type] = _generate_a_stylebox(type).duplicate()
		if popup_override_enabled:
			_popup_override_styleboxes[type] = _generate_a_stylebox(type, POPUP_OVERRIDE_PREFIX)
		else:
			_popup_override_styleboxes = _styleboxes
		if button_override_enabled:
			_button_override_styleboxes[type] = _generate_a_stylebox(type, BUTTON_OVERRIDE_PREFIX)
		else:
			_button_override_styleboxes = _styleboxes


func _generate_a_stylebox(type: String, override_prefix := "") -> StyleBox:
	var box : StyleBox
	#e.g. override_normal Fallback to override_normal >> override_default >> normal >> FALLBACK
	box = _get_first_valid(
		[get(override_prefix + STYLE_BOX_PREFIX + type),
		get(override_prefix + STYLE_BOX_PREFIX + "default"),
		get(STYLE_BOX_PREFIX + type),
		get(STYLE_BOX_PREFIX + "default"),
		STYLE_BOX_FALLBACK]
	).duplicate()
	var color : Color
	color = _get_first_valid(
		[get(override_prefix + COLOR_PREFIX + type),
		get(override_prefix + COLOR_PREFIX + "default"),
		get(COLOR_PREFIX + type),
		get(COLOR_PREFIX + "default"),
		COLOR_FALLBACK]
	)

	if box is StyleBoxFlat:
		box.bg_color = color
		if color_applied_to_border:
			box.border_color = color
		if type == "focus":
			box = box.duplicate()
			box.bg_color = Color.TRANSPARENT
			box.border_color = color

	elif box is StyleBoxLine:
		box.color = color
	
	
	return box


var _button_override_styleboxes: Dictionary[String, StyleBox] = {}
var _popup_override_styleboxes: Dictionary[String, StyleBox] = {}


func _get_first_valid(args: Array):
	for i in args:
		if i != null:
			return i

#endregion

#region Editor
func _validate_property(property: Dictionary) -> void:
	if _is_editable(property.name, BUTTON_OVERRIDE_PREFIX, button_override_enabled):
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if _is_editable(property.name, POPUP_OVERRIDE_PREFIX, popup_override_enabled):
		property.usage |= PROPERTY_USAGE_READ_ONLY

func _is_editable(name: String, prefix: String, flag: bool) -> bool:
	return name.begins_with(prefix) and (name != prefix + "enabled") and not flag

func _save_as_theme():
	if resource_path.is_absolute_path():
		var copy_path = resource_path.trim_suffix(".tres") + "_copy.tres"
		var copy = self.duplicate_deep(Resource.DEEP_DUPLICATE_INTERNAL)
		copy.set_script(null)
		ResourceSaver.save(copy, copy_path)
	printerr("Resource can not be converted as it has an invalid resource path")
#endregion
