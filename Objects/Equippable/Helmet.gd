extends Equippable

var original_pos: Vector2

func do_reset():
	if not equipped:
		position = original_pos

func _ready():
	original_pos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

