extends Item
class_name Equipable

enum EquipmentType { None, Head, Neck, Chest, Waist, Legs, Feet, Hand, Finger }

@export var equip_on_pickup: bool = false
@export var equipment_type : EquipmentType = EquipmentType.None

func equip():
	pass
	
func unequip():
	pass
