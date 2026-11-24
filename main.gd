extends Node2D

const SELECTABLE_ITEM = preload("uid://bmjk8b48dqtc6")
const SELECTABLE_ENEMY = preload("uid://bd2qwf6g5siqo")

@export var placed_items: Node2D
@export var help: Label
@export var background_objects: Node2D
@export var saved_indicator: Label
@export var layer_end: Node2D

@onready var enter_buttons: HBoxContainer = %EnterButtons
@onready var exit_buttons: HBoxContainer = %ExitButtons

const SCROLL_AMOUNT : float = 100.0
var save_location : String = ""
var autosave_timer : float
var layer_settings : Dictionary = {"enter_buttons" : [0,1,0], "exit_buttons" : [0,1,0], "end" : 1150.0}
var layer_end_target : float = 1150.0

const AUTOSAVE_TIME = 120.0

func _ready() -> void:
	saved_indicator.modulate.a = 0.0
	Global.main = self
	Global.placed_items = placed_items
	Debug.disable_console = true

func _process(delta: float) -> void:
	autosave_timer += delta
	if autosave_timer > AUTOSAVE_TIME:
		autosave_timer -= AUTOSAVE_TIME
		if save_location != "" : save(false)
	
	var lowest_pos : float = 0.0
	for item : SelectableItem in placed_items.get_children():
		if not item.placed: continue
		var item_lowest : float = item.position.y + item.collision_shape.shape.size.y / 2.0
		lowest_pos = maxf(lowest_pos, item_lowest)
	
	layer_end.position.y = maxf(lowest_pos, layer_end_target)
	layer_settings["end"] = layer_end.position.y
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_help"):
		help.visible = !help.visible
	
	if not Global.picked_item:
		if event.is_action_pressed("scroll_up"):
			placed_items.position.y += SCROLL_AMOUNT 
			background_objects.position.y = placed_items.position.y
		
		if event.is_action_pressed("scroll_down"):
			placed_items.position.y -= SCROLL_AMOUNT 
			background_objects.position.y = placed_items.position.y
	
	
	if event.is_action_pressed("save_as"):
		save(true)
		
	elif event.is_action_pressed("save"):
		save(false)
	
	if event.is_action_pressed("load"):
		load_layer()
	
	if event.is_action_pressed("toggle_exit_buttons"):
		enter_buttons.visible = !enter_buttons.visible
		exit_buttons.visible = enter_buttons.visible 
	
	if event.is_action_pressed("set_layer") and not event.is_action_pressed("load"):
		layer_end_target = get_global_mouse_position().y - background_objects.position.y 
	
	if event.is_action_pressed("show_collisions"):
		showing_collisions = !showing_collisions
		

func save(save_as : bool):
	if save_location == "" or save_as:
		var filepath : Array = ["", ""]
		filepath = await Util.open_file_dialog(self, FileDialog.FileMode.FILE_MODE_SAVE_FILE, [".layer"], "last", "Save layer file")
		if filepath == ["", ""]: return
		save_location = filepath[0]
	
	var data : Dictionary = {"layer_settings": layer_settings, "items" : []}
	for item : SelectableItem in placed_items.get_children():
		if not item.placed: continue
		var item_data : Dictionary = item.serialize()
		data["items"].append(item_data)
	 
	File.save_var_custom(save_location, data)
	
	print("Saved at: ", save_location)
	flash_text("Saved!", Color.SEA_GREEN)

var loading : bool = false
func load_layer():
	var filepath : Array = ["", ""]
	filepath = await Util.open_file_dialog(self, FileDialog.FileMode.FILE_MODE_OPEN_FILE, [".layer"], "last", "Open layer file")
	if filepath == ["", ""]: return
	save_location = filepath[0]
	
	loading = true
	var data : Dictionary = File.load_var_custom(save_location, {})
	if data == {}:
		flash_text("Invalid or corrupt file")
		return
	
	var new_layer_settings : Dictionary = data["layer_settings"]
	layer_settings = new_layer_settings
	layer_end.position.y = new_layer_settings["end"]
	print("load: ", layer_settings)
	
	
	for i : int in enter_buttons.get_children().size():
		enter_buttons.get_child(i).button_pressed = new_layer_settings["enter_buttons"][i]
	
	for i : int in exit_buttons.get_children().size():
		exit_buttons.get_child(i).button_pressed = new_layer_settings["exit_buttons"][i]
	
	for child in placed_items.get_children():
		child.queue_free()
	
	for entry : Dictionary in data["items"]:
		var inst := SELECTABLE_ITEM.instantiate() if not entry["is_enemy"] else SELECTABLE_ENEMY.instantiate()
		inst.deserialize(entry)
		placed_items.add_child(inst)
		
	 
	placed_items.position.y = 0
	background_objects.position.y = 0
	await get_tree().process_frame
	loading = false

func flash_text(text : String, color : Color = Color.WHITE):
	saved_indicator.text = text
	saved_indicator.modulate = color
	var tween : Tween = create_tween()
	tween.tween_property(saved_indicator, "modulate:a", 0.0, 3.0)


func _on_button_toggled(_toggled_on: bool) -> void:
	if loading: return
	layer_settings["exit_buttons"] = [exit_buttons.get_child(0).button_pressed, exit_buttons.get_child(1).button_pressed, exit_buttons.get_child(2).button_pressed]
	layer_settings["enter_buttons"] = [enter_buttons.get_child(0).button_pressed, enter_buttons.get_child(1).button_pressed, enter_buttons.get_child(2).button_pressed]
	print(layer_settings)

var showing_collisions : bool = false
const PLAYER_SIZE_CROUCH = Vector2(28.0, 48.0)
const PLAYER_SIZE_DEFAULT = Vector2(28.0, 2*48.0)

func _draw() -> void:
	if showing_collisions: 
		var player_size : Vector2 = PLAYER_SIZE_DEFAULT if Input.is_key_pressed(KEY_SHIFT) else PLAYER_SIZE_CROUCH
		draw_rect(Rect2(get_global_mouse_position() - player_size / 2.0, player_size),  Color("ff999999"), true, -1.0, true)
		draw_rect(Rect2(get_global_mouse_position() - player_size / 2.0, player_size),  Color("ff999999"), false, 3.0, true)
