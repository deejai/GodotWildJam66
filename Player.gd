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

@onready var equipped_sprite: AnimatedSprite2D = $CanvasLayer/EquippedSprite
@onready var label_pickup: Label = $CanvasLayer/Label_PickupItem
@onready var label_drop: Label = $CanvasLayer/Label_DropItem
@onready var label_use: Label = $CanvasLayer/Label_UseItem

var could_equip: Array[Equippable] = []
var equipped_item: Equippable = null

func _ready():
	animated_sprite.animation = "idle"

func _process(delta):
	animated_sprite.play()

func _physics_process(delta):
	if is_on_floor():
		time_until_airborne = AIRBORNE_TRIGGER_TIME
		coyote_timer = COYOTE_TIME
		if airborne:
			animated_sprite.animation = "idle"
		airborne = false
	else:
		time_until_airborne -= delta
		coyote_timer -= delta
		if airborne or time_until_airborne <= 0.0:
			airborne = true
			animated_sprite.animation = "jump"
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and coyote_timer > 0.0:
		airborne = true
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("walk_left", "walk_right")
	if direction:
		last_direction_x = direction
		velocity.x = direction * SPEED
		if not airborne:
			animated_sprite.animation = "walk"
		if direction > 0.0:
			# facing right
			animated_sprite.flip_h = false
		else:
			# facing left
			animated_sprite.flip_h = true
	else:
		if not airborne:
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

	if equipped_item and Input.is_action_just_pressed("use_item"):
		equipped_item.use()

	move_and_slide()

func update_gui():
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
