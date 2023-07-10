@tool
extends Control 
class_name Slot

#enum EquipmentSlotType
#{
#	None,
#	Helmet,
#	Neck,
#	Chest,
#	Waist,
#	Legs,
#	Boots,
#	Gloves,
#	LeftRing,
#	RightRing,
#	LeftHand,
#	RightHand
#}

@export var slot_index : int
@export var background_texture: Texture
@export var placeholder_texture: Texture
@export var item_texture: Texture
#@export var equipment_slot_type : EquipmentSlotType = EquipmentSlotType.None

@onready var background_texture_rect: TextureRect
@onready var placeholder_texture_rect: TextureRect
@onready var item_texture_rect: TextureRect

func _ready():
	pass
	
func set_background(text: Texture):
	background_texture_rect.texture = text

func set_placeholder(text: Texture):	
	placeholder_texture_rect.texture = text
	
func set_item(text: Texture):
	item_texture_rect.texture = text
	

