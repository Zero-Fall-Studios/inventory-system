@tool
extends Area2D
class_name Pickup

var item_data: Array[Item]
@export var item: Array[Item]:
	get:
		return item_data
	set(value):
		if value != item_data:
			item_data = value
			set_pickup_texture()
				
@export_group("Spawn Settings")
@export var autospawn: bool = false
@export var respawn_time: float = 1
@export var spawn_once_per_level: bool = false
@export var spawn_once_per_game: bool = false

@export_group("Pickup Events")
@export var random_item_on_pickup: bool = false
@export var pickup_on_collision: bool = true
@export var pickup_with_mouse_click: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var spawn_timer: Timer = $SpawnTimer

var is_mouse_over = false
var center : Vector2
var local_collision_pos : Vector2

func _ready():
	connect("body_entered", Callable(self, "_on_body_enter"))
	connect("body_exited", Callable(self, "_on_body_exit"))
	connect("input_event", Callable(self, "_on_input_event"))
	
	set_pickup_texture()
	center.x = sprite.get_rect().size.x / 2
	center.y = sprite.get_rect().size.y / 2
	
	hide()
	
	spawn_timer.wait_time = respawn_time
	spawn_timer.one_shot = spawn_once_per_level
	if autospawn:
		spawn_timer.start()
	
func _on_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("left_click"):
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		pickup_handler(get_global_mouse_position())

func set_pickup_texture():
	if sprite and item_data[0]:
		sprite.texture = item_data[0].inventory_sprite

func spawn():
	show()
	spawn_timer.stop()
	
func pickup_handler(coords : Vector2):
	if random_item_on_pickup:
		item_data.shuffle()
		PickupSignalBus.pickup_event.emit(coords, [item_data[0]])
		return

	PickupSignalBus.pickup_event.emit(coords, item_data)
	
	hide()
	
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
#	todo - spawn_once_per_game need to get this from an inventory somehoe
	var has_item_in_inventory = false
	var cant_spawn = (has_item_in_inventory and spawn_once_per_game) or spawn_once_per_level
	
	if not cant_spawn:
		spawn_timer.start()

func _integrate_forces( state ):
	if(state.get_contact_count() >= 1):  #this check is needed or it will throw errors 
		local_collision_pos = state.get_contact_local_pos(0)

func _body_entered(body):
	if pickup_on_collision:
		var collision_position = local_collision_pos + get_position()
		pickup_handler(collision_position)
	
func _on_timer_timeout():
	spawn()
