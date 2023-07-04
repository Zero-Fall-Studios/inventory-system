@tool
extends TextureRect
class_name Slot

enum EquipmentSlotType
{
	Helmet,
	Neck,
	Chest,
	Waist,
	Legs,
	Boots,
	Gloves,
	LeftRing,
	RightRing,
	LeftHand,
	RightHand
}

@export var slot_index : int
@export var slot_texture: Texture
@export var slot_type : EquipmentSlotType

var slot_graphic_texture_data: Texture
@export var slot_graphic_texture: Texture:
	get:
		return slot_graphic_texture_data
	set(value):
		if value != slot_graphic_texture_data:
			slot_graphic_texture_data = value
			if slot_graphic:
				slot_graphic.texture = slot_graphic_texture_data

@onready var slot_graphic = $SlotGraphic

func _ready():
	texture = slot_texture
	slot_graphic.texture = slot_graphic_texture_data
	
#	shader_parameter/color
