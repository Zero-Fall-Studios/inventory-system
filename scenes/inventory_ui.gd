@tool
extends CanvasLayer
class_name InventoryUI

@export var inventory: Inventory
@export var slot_texture: Texture
@export var slot : PackedScene

@onready var container : VBoxContainer = $Panel/InventorySlots/VBoxContainer

var inventory_grid: Vector2
@export var grid: Vector2:
	get:
		return inventory_grid
	set(value):
		if value != inventory_grid:
			inventory_grid = value
			_create_grid()

func _ready():
	inventory.connect("inventory_change", _on_inventory_change)
	inventory.connect("equipment_change", _on_equipment_change)
	_create_grid()

func _create_grid():	
	if not container:
		return
	for child in container.get_children():
		child.queue_free()
	var slot_index = 0
	for i in range(grid.x):
		var row = HBoxContainer.new()
		row.name = "Row" + str(i)
		for j in range(grid.y):
			var col = slot.instantiate()
			col.name = "Row" + str(i) + "Col" + str(j)
			col.slot_index = slot_index
			col.texture = slot_texture
			slot_index += 1
			row.add_child(col)
		container.add_child(row)
		
func _on_inventory_change():
	for slot in get_tree().get_nodes_in_group("slot"):
		var item = inventory.get_slot(slot.slot_index)
		if item:
			slot.slot_graphic_texture = item.inventory_sprite
	
func _on_equipment_change():
	print("_on_equipment_change")

