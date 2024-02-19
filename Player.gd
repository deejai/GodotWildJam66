extends CharacterBody2D

class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -760.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var airborne: bool = false
const AIRBORNE_TRIGGER_TIME: float = 0.25
var time_until_airborne: float = AIRBORNE_TRIGGER_TIME
var COYOTE_TIME: float = 0.15
var coyote_timer:float = 0.0
var last_direction_x: float = 1.0
var could_climb: bool = false
var climbing: bool = false
const CLIMB_CD: float = 0.3
var climb_timer: float = 0.0

@onready var equipped_sprite: AnimatedSprite2D = $CanvasLayer/EquippedSprite
@onready var label_pickup: Label = $CanvasLayer/Label_PickupItem
@onready var label_drop: Label = $CanvasLayer/Label_DropItem
@onready var label_use: Label = $CanvasLayer/Label_UseItem

var could_equip: Array[Equippable] = []
var equipped_item: Equippable = null

var original_pos: Vector2

func do_reset():
	position = original_pos

func _ready():
	original_pos = position
	animated_sprite.animation = "idle"

func _process(delta):
	animated_sprite.play()

func _physics_process(delta):
	if get_parent().sleep_time:
		return

	climb_timer -= delta

	if could_climb == false:
		climbing = false

	if is_on_floor() or climbing:
		time_until_airborne = AIRBORNE_TRIGGER_TIME
		coyote_timer = COYOTE_TIME
		if climbing:
			animated_sprite.animation = "climb"
		elif airborne:
			animated_sprite.animation = "idle"
		airborne = false
	else:
		time_until_airborne -= delta
		coyote_timer -= delta
		if airborne or time_until_airborne <= 0.0:
			airborne = true
			animated_sprite.animation = "jump"
		velocity.y += gravity * delta

	var direction = Input.get_axis("walk_left", "walk_right")
	if direction:
		last_direction_x = direction
		velocity.x = direction * SPEED
		if not airborne and not climbing:
			animated_sprite.animation = "walk"
		if direction > 0.0:
			# facing right
			animated_sprite.flip_h = false
		else:
			# facing left
			animated_sprite.flip_h = true
	else:
		if not airborne and not climbing:
			animated_sprite.animation = "idle"
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if last_direction_x > 0.0 and equipped_item and equipped_item.scale.x < 0.0:
		equipped_item.scale.x *= -1.0
		equipped_item.position.x *= -1.0
	elif last_direction_x < 0.0 and equipped_item and equipped_item.scale.x > 0.0:
		equipped_item.scale.x *= -1.0
		equipped_item.position.x *= -1.0

	if Input.is_action_just_pressed("pickup_or_drop"):
		if equipped_item:
			equipped_item.unequip()
		elif not could_equip.is_empty():
			could_equip[0].equip(self)

	if equipped_item and equipped_item.can_use and Input.is_action_just_pressed("use_item"):
		equipped_item.use()

	if Input.is_action_just_pressed("jump") and coyote_timer > 0.0:
		airborne = true
		climbing = false
		climb_timer = CLIMB_CD
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_pressed("climb_up"):
		if could_climb and climbing == false and climb_timer <= 0.0 and not (equipped_item and equipped_sprite.frame == Equippable.Type.LADDER):
			climbing = true
		elif climbing:
			position.y -= 150.0 * delta
	elif Input.is_action_pressed("climb_down"):
		if climbing:
			position.y += 150.0 * delta

	if climbing:
		animated_sprite.frame = 1 if fmod(position.y / 200.0, 1.0) > 0.5 else 0
		velocity.y = 0.0
	else:
		pass

	move_and_slide()

func kill():
	print("You died!")

func update_gui():
	if equipped_item:
		equipped_sprite.frame = equipped_item.type
	label_pickup.visible = equipped_item == null and not could_equip.is_empty()
	label_drop.visible = equipped_item != null and not equipped_item.in_use
	label_use.visible = equipped_item != null and equipped_item.can_use and not equipped_item.in_use

func _on_animated_sprite_2d_frame_changed():
	#print(animated_sprite.animation)
	#print(animated_sprite.frame)
	pass

func _on_pickup_area_area_entered(area: Area2D):
	var obj = area.get_parent()
	if equipped_item == null and obj is Equippable:
		if obj not in could_equip:
			could_equip.append(obj)
		update_gui()

func _on_pickup_area_area_exited(area):
	var obj = area.get_parent()
	if equipped_item == null and obj is Equippable:
		if obj in could_equip:
			could_equip.erase(obj)
		update_gui()
