extends Equippable

var original_pos: Vector2

func do_reset():
	if not equipped:
		position = original_pos

func _ready():
	original_pos = position
	pass

func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body is Player:
		body.could_climb = true


func _on_area_2d_body_exited(body):
	if body is Player:
		body.could_climb = false
