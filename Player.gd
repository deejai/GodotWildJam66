extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var airborne: bool = false
const AIRBORNE_TRIGGER_TIME: float = 0.1
var time_until_airborne: float = AIRBORNE_TRIGGER_TIME

func _ready():
	animated_sprite.animation = "idle"

func _process(delta):
	animated_sprite.play()

func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		time_until_airborne = AIRBORNE_TRIGGER_TIME
		if airborne:
			animated_sprite.animation = "idle"
		airborne = false
	else:
		time_until_airborne -= delta
		if airborne or time_until_airborne <= 0.0:
			airborne = true
			animated_sprite.animation = "jump"
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		airborne = true
		velocity.y = JUMP_VELOCITY*2

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("walk_left", "walk_right")
	if direction:
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

	move_and_slide()

func _on_animated_sprite_2d_frame_changed():
	print(animated_sprite.animation)
	print(animated_sprite.frame)
