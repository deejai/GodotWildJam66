extends Equippable

@onready var collision_area: Area2D = $HitArea
var rotation_amount: float = 0.0

func _ready():
	collision_area.monitoring = false

func _process(delta):
	if in_use:
		rotation_amount = lerp(rotation_amount, PI/2.0, 1 - pow(0.000001, delta))
		rotation = rotation_amount * sign(scale.x)
		if rotation_amount >= 0.99 * PI / 2.0:
			rotation_amount = 0.0
			rotation = 0.0
			in_use = false
			collision_area.monitoring = false

func use():
	if in_use:
		return
	in_use = true
	collision_area.monitoring = true

func _on_hit_area_area_entered(area):
	print(area.get_parent())
	if area.get_parent() is BrickWall:
		area.get_parent().destroy()
	print("!")
