extends Resource
class_name Inventory

@export var money: int = 0
@export var max_slots = 50
@export var items: Array[Item] = []

enum EquipmentSlotType {
	Helmet,
	Neck,
	Chest,
	Waist,
	Legs,
	Boots,
	Gloves,
	LeftFinger,
	RightFinger,
	LeftHand,
	RightHand
}

@export_group("Equipment")
@export var helmet: Item
@export var neck: Item
@export var chest: Item
@export var waist: Item
@export var legs: Item
@export var boots: Item
@export var gloves: Item
@export var left_finger: Item
@export var right_finger: Item
@export var left_hand: Item
@export var right_hand: Item

signal inventory_change
signal equipment_change

func _init():
	call_deferred("_ready")

func _ready():
	items.resize(max_slots)
	items.fill(null)
	PickupSignalBus.connect("pickup_event", _on_pickup_event)

func _on_pickup_event(coords: Vector2, items: Array[Item]):
	for item in items:
		add(item)
	
func get_size():
	return items.size()
	
func add(item: Item):	
	# Consume the item, no need to add to inventory
	if item.consume_on_pickup:
		print("Consume")
		consume(item)
		
	if in_inventory(item) and item.is_unique:
		print("Item is unique")
		return
		
	if in_inventory(item) and item.is_stackable and item.quantity < item.max_stackable_count:
		print("Add quantity")
		add_quantity(item, item.quantity)
		return

	if item.equip_on_pickup:
		print("Equip")
		equip(item, get_equipment_slot_type(item))
	else:
		var next_slot = get_next_available_slot()
		if next_slot >= 0:
			print("Next Slot", next_slot)
			set_slot(next_slot, item)
	
func remove(item: Item):
	items.erase(item)
	inventory_change.emit()

func add_quantity(item: Item, amount: int):
	item.quantity += amount
	if item.quantity <= 0:
		remove(item)
	inventory_change.emit()
	
func add_money(amount: int):
	money += amount
	
func in_inventory(item: Item):
	return items.has(item)
	
func get_slot(slot_index):
	return items[slot_index]
	
func get_slot_index(item: Item):
	var found_item = items.find(item)
	if found_item:
		return found_item.slot_index
	return -1
	
func set_slot(slot_index, item: Item):
	items[slot_index] = item
	inventory_change.emit()
	
func remove_slot(slot_index, item: Item):
	items[slot_index] = null
	inventory_change.emit()
	
func get_next_available_slot():
	for i in range(max_slots):
		if not items[i]:
			return i
	return -1
			
func get_equipment_slot_type(item: Item):
	match item.armor_type:
		Item.ArmorType.Head:
			return EquipmentSlotType.Helmet
		Item.ArmorType.Neck:
			return EquipmentSlotType.Neck
		Item.ArmorType.Chest:
			return EquipmentSlotType.Chest
		Item.ArmorType.Waist:
			return EquipmentSlotType.Waist
		Item.ArmorType.Legs:
			return EquipmentSlotType.Legs
		Item.ArmorType.Feet:
			return EquipmentSlotType.Boots
		Item.ArmorType.Hand:
			if not left_hand:
				return EquipmentSlotType.LeftHand
			else:
				return EquipmentSlotType.RightHand
		Item.ArmorType.Finger:
			if not left_finger:
				return EquipmentSlotType.LeftFinger
			else:
				return EquipmentSlotType.RightFinger
				
func equip(item: Item, equipment_slot_type: EquipmentSlotType):
	print("Equip")
	match equipment_slot_type:
		EquipmentSlotType.Helmet:
			helmet = item
		EquipmentSlotType.Neck:
			neck = item
		EquipmentSlotType.Chest:
			chest = item
		EquipmentSlotType.Waist:
			waist = item
		EquipmentSlotType.Legs:
			legs = item
		EquipmentSlotType.Boots:
			boots = item
		EquipmentSlotType.LeftHand:
			left_hand = item
		EquipmentSlotType.RightHand:
			right_hand = item
		EquipmentSlotType.LeftFinger:
			left_finger = item
		EquipmentSlotType.RightFinger:
			right_finger = item
	equipment_change.emit()
	
func unequip(equipment_slot_type: EquipmentSlotType):
	match equipment_slot_type:
		EquipmentSlotType.Helmet:
			helmet = null
		EquipmentSlotType.Neck:
			neck = null
		EquipmentSlotType.Chest:
			chest = null
		EquipmentSlotType.Waist:
			waist = null
		EquipmentSlotType.Legs:
			legs = null
		EquipmentSlotType.Boots:
			boots = null
		EquipmentSlotType.LeftHand:
			left_hand = null
		EquipmentSlotType.RightHand:
			right_hand = null
		EquipmentSlotType.LeftFinger:
			left_finger = null
		EquipmentSlotType.RightFinger:
			right_finger = null
	equipment_change.emit()
	
func consume(item: Item):
	item.consume()
	if item.is_stackable and item.quantity > 0:
		add_quantity(item, -1)
	else:
		remove(item)
