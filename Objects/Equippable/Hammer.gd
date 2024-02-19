extends Equippable

@onready var hit_area: Area2D = $HitArea
var rotation_amount: float = 0.0
var original_pos: Vector2

func do_reset():
	if not equipped:
		position = original_pos

func _ready():
	original_pos = position
	hit_area.monitoring = false

func _process(delta):
	if in_use:
		rotation_amount = lerp(rotation_amount, PI/2.0, 1 - pow(0.000001, delta))
		rotation = rotation_amount * sign(scale.x)
		if rotation_amount >= 0.99 * PI / 2.0:
			rotation_amount = 0.0
			rotation = 0.0
			in_use = false
			hit_area.monitoring = false

func use():
	if in_use:
		return
	in_use = true
	hit_area.monitoring = true

func _on_hit_area_area_entered(area):
	print(area.get_parent())
	if area.get_parent() is BrickWall:
		area.get_parent().destroy()
	print("!")

