extends Node

const ITEMS : Dictionary = {
	"Goober" : {
		"Goober" : {
			"texture": preload("res://Enemies/Goober.png"),
			"scale" : 0.7,
			"hitbox_scale" : Vector2(85.0, 121.0),
			"hitbox_offset" : Vector2(0.0, 0.0)
		}
	},
	"Bouncer" : {
		"Bouncer" : {
			"texture": preload("res://Enemies/Bouncer.png"),
			"scale" : 1.5,
			"hitbox_scale" : Vector2(119.0, 83.0),
			"hitbox_offset" : Vector2(17.0, 0.0)
		}
	},
	"Spewer" : {
		"Spewer" : {
			"texture": preload("res://Enemies/Spewer.png"),
			"scale" : 1.5,
			"hitbox_scale" : Vector2(60.0, 122.0),
			"hitbox_offset" : Vector2(70.0, -7.0)
		}
	},
	
	"BigBlock" : {
		"BigBlock1" : {
			"texture": preload("res://Objects/BigBlock1.png"),
			"hitbox_scale" : Vector2(372.0, 204.0),
			"hitbox_offset" : Vector2(0.0, 15.0)
		}, 
		"BigBlock2" : {
			"texture": preload("res://Objects/BigBlock2.png"),
			"hitbox_scale" : Vector2(351.0, 196.0),
			"hitbox_offset" : Vector2(-10.0, 11.0)
		}, 
		"BigBlock3" : {
			"texture": preload("res://Objects/BigBlock3.png"),
			"hitbox_scale" : Vector2(351.0, 196.0),
			"hitbox_offset" : Vector2(0.0, 14.0)
		}
	},
	
	"SmallBlock" : {
		"SmallBlock1" : {
			"texture": preload("res://Objects/SmallBlock1.png"),
			"hitbox_scale" : Vector2(172.0, 160.0),
			"hitbox_offset" : Vector2.ZERO
		}, 
		"SmallBlock2" : {
			"texture": preload("res://Objects/SmallBlock2.png"),
			"hitbox_scale" : Vector2(157.0, 154.0),
			"hitbox_offset" : Vector2.ZERO
		}, 
		"SmallBlock3" : {
			"texture": preload("res://Objects/SmallBlock3.png"),
			"hitbox_scale" : Vector2(120.0, 142.0),
			"hitbox_offset" : Vector2.ZERO
		}
	},
	
	"BigFlat" : {
		"BigFlat1" : {
			"texture": preload("res://Objects/BigFlat1.png"),
			"hitbox_scale" : Vector2(373.0, 111.0),
			"hitbox_offset" : Vector2(-3.5, 4.5)
		}, 
		"BigFlat2" : {
			"texture": preload("res://Objects/BigFlat2.png"),
			"hitbox_scale" : Vector2(358.0, 111.0),
			"hitbox_offset" : Vector2(-11.0, 1.0)
		}, 
		"BigFlat3" : {
			"texture": preload("res://Objects/BigFlat3.png"),
			"hitbox_scale" : Vector2(355.0, 86.0),
			"hitbox_offset" : Vector2(-12.5, -14.0)
		}
	},
	
	"SmallFlat" : {
		"SmallFlat1" : {
			"texture": preload("res://Objects/SmallFlat1.png"),
			"hitbox_scale" : Vector2(70.0, 34.0),
			"hitbox_offset" : Vector2.ZERO
		}, 
		"SmallFlat2" : {
			"texture": preload("res://Objects/SmallFlat2.png"),
			"hitbox_scale" : Vector2(71.0, 30.0),
			"hitbox_offset" : Vector2(-8.5, 4.0)
		}, 
		"SmallFlat3" : {
			"texture": preload("res://Objects/SmallFlat3.png"),
			"hitbox_scale" : Vector2(79.0, 31.0),
			"hitbox_offset" : Vector2(1.5, 4.5)
		}
	},
	
	"BigWall" : {
		"BigWall1" : {
			"texture": preload("res://Objects/BigWall1.png"),
			"hitbox_scale" : Vector2(158.0, 658.0),
			"hitbox_offset" : Vector2.ZERO
		}, 
		"BigWall2" : {
			"texture": preload("res://Objects/BigWall2.png"),
			"hitbox_scale" : Vector2(168.0, 654.0),
			"hitbox_offset" : Vector2(8.0, 6.0)
		}, 
		"BigWall3" : {
			"texture": preload("res://Objects/BigWall3.png"),
			"hitbox_scale" : Vector2(161.0, 663.0),
			"hitbox_offset" : Vector2(3.5, 1.5)
		}
	},
	
	"SmallWall" : {
		"SmallWall1" : {
			"texture": preload("res://Objects/SmallWall1.png"),
			"hitbox_scale" : Vector2(169.0, 332.0),
			"hitbox_offset" : Vector2.ZERO
		}, 
		"SmallWall2" : {
			"texture": preload("res://Objects/SmallWall2.png"),
			"hitbox_scale" : Vector2(182.5, 320.0),
			"hitbox_offset" : Vector2(-6.75, 6.0)
		}, 
		"SmallWall3" : {
			"texture": preload("res://Objects/SmallWall3.png"),
			"hitbox_scale" : Vector2(184.0, 352.0),
			"hitbox_offset" : Vector2(10.0, 3.0)
		}
	},
	
	"BigLava" : {
		"BigLava1" : {
			"texture": preload("res://Objects/BigLava1.png"),
			"hitbox_scale" : Vector2(188.0, 248.0),
			"hitbox_offset" : Vector2(0.0, 2.0)
		}, 
		"BigLava2" : {
			"texture": preload("res://Objects/BigLava2.png"),
			"hitbox_scale" : Vector2(188.0, 248.0),
			"hitbox_offset" : Vector2(0.0, -28.0)
		}, 
		"BigLava3" : {
			"texture": preload("res://Objects/BigLava3.png"),
			"hitbox_scale" : Vector2(188.0, 239.0),
			"hitbox_offset" : Vector2(0.0, -23.5)
		}
	},
	
	"SmallLava" : {
		"SmallLava1" : {
			"texture": preload("res://Objects/SmallLava1.png"),
			"hitbox_scale" : Vector2(91.0, 158.0),
			"hitbox_offset" : Vector2(2.5, 3.0)
		}, 
		"SmallLava2" : {
			"texture": preload("res://Objects/SmallLava2.png"),
			"hitbox_scale" : Vector2(87.0, 152.0),
			"hitbox_offset" : Vector2(4.5, -6.0)
		}, 
		"SmallLava3" : {
			"texture": preload("res://Objects/SmallLava3.png"),
			"hitbox_scale" : Vector2(89.0, 147.0),
			"hitbox_offset" : Vector2(3.5, -8.5)
		}
	}
}

var selected : SelectableItem
var picked_item : SelectableItem

var placed_items : Node2D
var main : Node2D

func _ready() -> void:
	randomize()
