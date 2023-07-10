@tool
extends Area2D
class_name InventorySlotItem

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

var selected = false
var is_mouse_over = false
var center : Vector2

func _ready():
	connect("mouse_entered", Callable(self, "_on_mouse_enter"))
	connect("mouse_exited", Callable(self, "_on_mouse_exit"))
	connect("input_event", Callable(self, "_on_input_event"))
	center.x = sprite.get_rect().size.x / 2
	center.y = sprite.get_rect().size.y / 2
	
func _on_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("left_click"):
		selected = true	
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if selected:
				selected = false
				Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _physics_process(_delta):
	if selected:
		global_position = get_global_mouse_position()

func _mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	is_mouse_over = true

func _mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	is_mouse_over = false
