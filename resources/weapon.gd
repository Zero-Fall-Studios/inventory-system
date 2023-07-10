extends Equipable
class_name Weapon

enum WeaponState { 
	Idle, 
	MeleeStarted, MeleeEnded, 
	CooldownStarted, InCooldown, CooldownEnded, 
	ChargingStarted, IsCharging, ChargingEnded,
	FireStarted, IsFiring, FireEnded
}

@export var weapon_state : WeaponState = WeaponState.Idle
@export var fire_rate: float = 0

@export_subgroup("Charge")
@export var is_charging: bool = false
@export var charge_time: float = 0
@export var fire_when_charged: bool = false
@export var fire_when_button_released: bool = false

@export_subgroup("Cooldown")
@export var cooldown_rate: float = 0
@export var is_in_cooldown: bool = false

@export_subgroup("Clip")
@export var total_clip_amount: int = 0
@export var clip_amount: int = 0
@export var reload: float = 0

@export_subgroup("Ammo")
@export var ammo_count: int = 0
@export var max_ammo: int = 0
@export var starting_ammo_count: int = 0
@export var refill_ammo_count: int = 0
@export var gain_ammo_over_time_rate: float = 0
@export var ammo_to_gain_over_time: int = 0
@export var unlimited_ammo: bool = false

func equip():
	pass
	
func unequip():
	pass
