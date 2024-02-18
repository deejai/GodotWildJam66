extends DirectionalLight2D

var time_elapsed: float = randf()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	energy = 0.08 + 0.04 * sin(2 * PI * time_elapsed)
