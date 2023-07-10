extends Resource
class_name Item

@export var inventory_sprite: Texture
@export var game_sprite: Texture

@export_group("General")
@export var is_unique: bool = false

@export_group("Stackable")
@export var is_stackable: bool = false
@export var max_stackable_count: int = 50
@export var quantity: int = 1
