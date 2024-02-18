extends RigidBody2D

class_name Equippable

@export var equip_offset_x: float = 0.0
@export var equip_offset_y: float = 0.0
@export var can_use: bool = true
var in_use: bool = false
var player: Player = null

enum Type {HAMMER=1, FLASHLIGHT, HELMET}
@export var type: Type

func equip(player: Player):
	self.player = player
	player.equipped_item = self
	reparent(player)
	lock_rotation = false
	collision_mask = 0
	collision_layer = 0
	position.x = equip_offset_x
	position.y = equip_offset_y
	freeze = true
	if player.last_direction_x > 0.0 and scale.x < 0.0:
		scale.x *= -1.0
		position.x *= -1.0
	elif player.last_direction_x < 0.0 and scale.x > 0.0:
		scale.x *= -1.0
		position.x *= -1.0

func unequip():
	player.equipped_item = null
	position.x = 0.0
	position.y = 0.0
	reparent(player.get_parent())
	rotation = 0
	lock_rotation = true
	collision_mask = 2
	collision_layer = 2
	freeze = false
