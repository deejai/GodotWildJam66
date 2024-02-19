extends RigidBody2D

class_name Equippable

@export var equip_offset_x: float = 0.0
@export var equip_offset_y: float = 0.0
@export var can_use: bool = true
var equipped: bool = false
var in_use: bool = false
var player: Player = null
@export var visible_while_equipped: bool = true

enum Type {NOTHING, HAMMER, FLASHLIGHT, HELMET, LADDER, BAT}
@export var type: Type = Type.NOTHING

func equip(player: Player):
	self.player = player
	player.equipped_item = self
	player.equipped_sprite.frame = type
	equipped = true
	if not visible_while_equipped:
		visible = false
	reparent(player)
	lock_rotation = false
	collision_mask = 0
	position.x = equip_offset_x
	position.y = equip_offset_y
	freeze = true
	if player.last_direction_x > 0.0 and scale.x < 0.0:
		scale.x *= -1.0
		position.x *= -1.0
	elif player.last_direction_x < 0.0 and scale.x > 0.0:
		scale.x *= -1.0
		position.x *= -1.0
	if type == Type.LADDER:
		player.climbing = false

func unequip():
	if in_use:
		return
	player.equipped_item = null
	player.equipped_sprite.frame = Type.NOTHING
	equipped = false
	visible = true
	position.x = 0.0
	position.y = 0.0
	reparent(player.get_parent())
	rotation = 0
	lock_rotation = true
	collision_mask = 2
	freeze = false
	position.y += 16.0
	linear_velocity.y += 10.0
	call_deferred("apply_central_impulse", Vector2.DOWN * 40.0)
