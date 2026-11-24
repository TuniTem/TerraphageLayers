extends SelectableItem
class_name SelectableEnemy

@onready var chance_label: Label = $Chance

var chance : float = 1.0

func _ready() -> void:
	rendered_item = item
	is_enemy = true
	super()

func _process(delta: float) -> void:
	chance_label.text = str(roundi(chance * 100)) + "%"
	super(delta)

func _input(event: InputEvent) -> void:
	if Global.picked_item == self:
		if event.is_action_pressed("increase_enemy_chance"):
			add_chance(0.05 * (1.0 if not Input.is_key_pressed(KEY_SHIFT) else 5.0))
		
		if event.is_action_pressed("decrease_enemy_chance"):
			add_chance(-0.05 * (1.0 if not Input.is_key_pressed(KEY_SHIFT) else 5.0))
		
	
	super(event)


func add_chance(amount : float):
	chance = clampf(chance + amount, 0.0, 1.0)

func serialize() -> Dictionary:
	return {
		"item" : item,
		"rendered_item" : rendered_item,
		"is_enemy" : true,
		"prev_rendered": "",
		"placed" : placed,
		"position" : position,
		"set_scale" : set_scale,
		"rotation_int" : rotation_int,
		"z_index" : z_index,
		"chance" : chance
	}
