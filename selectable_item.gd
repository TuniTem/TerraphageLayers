extends Area2D
class_name SelectableItem

const SELECTABLE_ITEM = preload("uid://bmjk8b48dqtc6")
const SELECTABLE_ENEMY = preload("uid://bd2qwf6g5siqo")

const SCALE_MULT = 1.1

@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var sprite: Sprite2D = $Sprite
@onready var hitbox: ReferenceRect = $Hitbox


@export var item : String
var rendered_item : String
var prev_rendered : String

var mouse_in_area : bool = false
var placed : bool = false
var disabled : bool = false
var dragging : bool = false

var drag_offset : Vector2
var rotation_int : int = 0
var is_enemy : bool = false
var set_scale : Vector2 = Vector2.ONE

var item_data : Dictionary:
	get(): 
		if item and rendered_item: return Global.ITEMS[item][rendered_item].duplicate()
		else: return {}

func _ready() -> void:
	if is_enemy: scale = set_scale * item_data["scale"]
	else: scale = set_scale
	
	if not is_enemy and not rendered_item:
		rendered_item = item + ["1", "2", "3"].pick_random()

func _process(delta: float) -> void:
	
		#print(mouse_in_area)
		#print(Global.selected)
	if mouse_in_area and not Global.picked_item == self and not disabled:
		Global.selected = self
	
	elif Global.selected == self:
		Global.selected = null
	
	if Global.picked_item == self:
		if Input.is_action_just_released("drag"): 
			if placed and global_position.x > 900.0:
				delete()
				
			Global.picked_item = null
		
		else:
			global_position = get_global_mouse_position() + drag_offset
		
		#print(sprite.texture)
	
	elif Input.is_action_just_pressed("drag") and Global.selected == self and not disabled: 
		if placed:
			Global.picked_item = self
			drag_offset = global_position - get_global_mouse_position() 
			
		else:
			print("spawn new")
			disabled = true
			var inst := SELECTABLE_ITEM.instantiate() if not is_enemy else SELECTABLE_ENEMY.instantiate()
			inst.item = item
			if is_enemy: inst.rendered_item = item
			inst.is_enemy = is_enemy
			inst.placed = true
			inst.disabled = false
			inst.drag_offset = global_position - get_global_mouse_position() 
			inst.scale = Vector2.ONE
			Global.placed_items.add_child(inst)
			Global.picked_item = inst
			
	
	if item and rendered_item:
		var mouse_pos : Vector2 = get_global_mouse_position()
		var pos : Vector2 = global_position + collision_shape.position.rotated(PI * float(rotation_int) / 2.0)
		var center : Vector2 = collision_shape.shape.size/2.0 * scale.abs()
		#if rotation_int % 2 == 1:
			#mouse_in_area = mouse_pos.y < center.y + pos.y and mouse_pos.y > -center.y + pos.y and mouse_pos.x < center.x + pos.x and mouse_pos.x > -center.x + pos.x
		mouse_in_area = mouse_pos.y < center.y + pos.y and mouse_pos.y > -center.y + pos.y and mouse_pos.x < center.x + pos.x and mouse_pos.x > -center.x + pos.x
		if !mouse_in_area: disabled = false
		#print(mouse_in_area)
		if prev_rendered != rendered_item:
			update_visual()
	
	var brightness : float = 1.2 if Global.selected == self and not Global.picked_item == self else 1.0
	modulate = Color(brightness, brightness, brightness, 0.6 if Global.picked_item == self else 1.0)
	prev_rendered = rendered_item
	

func _input(event: InputEvent) -> void:
	if Global.picked_item == self:
		if event.is_action_pressed("next_texture"):
			if is_enemy: return
			var item_idx : int = Global.ITEMS[item].keys().find(rendered_item)
			rendered_item = Global.ITEMS[item].keys()[wrapi(item_idx + 1, 0, 3)]
		
		if event.is_action_pressed("delete"):
			delete()
		
		if event.is_action_pressed("flip_h"):
			scale.x = -scale.x
			set_scale = scale if not is_enemy else scale / item_data["scale"]
		
		if event.is_action_pressed("flip_v"):
			scale.y = -scale.y
			set_scale = scale if not is_enemy else scale / item_data["scale"]
		
		if event.is_action_pressed("scale_up"):
			scale *= SCALE_MULT
			set_scale = scale if not is_enemy else scale / item_data["scale"]
			drag_offset *= SCALE_MULT
		
		if event.is_action_pressed("scale_down"):
			scale /= SCALE_MULT
			set_scale = scale if not is_enemy else scale / item_data["scale"]
			drag_offset /= SCALE_MULT
		
		if event.is_action_pressed("increase_render_layer"):
			z_index += 1
		
		if event.is_action_pressed("decrease_render_layer"):
			z_index -= 1
		
		if event.is_action_pressed("rotate_left"):
			rotation_int = wrapi(rotation_int + 1, 0, 4)
			update_visual()
		
		if event.is_action_pressed("rotate_right"):
			rotation_int = wrapi(rotation_int - 1, 0, 4)
			update_visual()


func update_visual():
	if is_enemy: scale = set_scale * item_data["scale"]
	else : scale = set_scale
	sprite.texture = item_data["texture"]
	hitbox.size = item_data["hitbox_scale"]
	hitbox.position = item_data["hitbox_offset"] - hitbox.size / 2.0
	
	collision_shape.shape.size = item_data["hitbox_scale"]
	collision_shape.position = item_data["hitbox_offset"]
	
	var rotation_float : float = rotation_int
	sprite.rotation = PI * rotation_float / 2.0
	if rotation_int % 2 == 1:
		collision_shape.shape.size = Vector2(collision_shape.shape.size.y, collision_shape.shape.size.x)
		hitbox.size = Vector2(hitbox.size.y, hitbox.size.x)
	
	collision_shape.position = collision_shape.position.rotated(PI * rotation_float / 2.0)
	hitbox.position = hitbox.position.rotated(PI * rotation_float / 2.0)

func delete():
	queue_free()


func serialize() -> Dictionary:
	return {
		"item" : item,
		"rendered_item" : rendered_item,
		"is_enemy" : is_enemy,
		"prev_rendered": "",
		"placed" : placed,
		"position" : position,
		"set_scale" : set_scale,
		"rotation_int" : rotation_int,
		"z_index" : z_index
	}

func deserialize(data : Dictionary):
	
	for key : String in data.keys():
		set(key, data[key])

#func _on_mouse_entered() -> void:
	#mouse_in_area = true
	#print("mouse_entered")
#
#func _on_mouse_exited() -> void:
	#mouse_in_area = false
	#disabled = false
	#print("mouse_exitied")
