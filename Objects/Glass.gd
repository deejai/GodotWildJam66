extends StaticBody2D

class_name Glass

enum BreakState {LEFT=0, MIDDLE, RIGHT}
@export var break_state: BreakState = BreakState.MIDDLE
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	pass

func _process(delta):
	pass

func destroy():
	animated_sprite.stop()
	animated_sprite.animation = "broken"
	animated_sprite.frame = break_state
	collision_layer = 0
	collision_mask = 0

func do_reset():
	animated_sprite.animation = "normal"
	animated_sprite.play()
	collision_layer = 1
	collision_mask = 1
