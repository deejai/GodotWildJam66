extends Node2D

@onready var point_light: PointLight2D = $PointLight2D
var base_energy: float
const energy_variance: float = 0.065
const energy_period: float = 1.5
var time_elapsed: float = randf() * energy_period

# Called when the node enters the scene tree for the first time.
func _ready():
	base_energy = point_light.energy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	point_light.energy = base_energy * ((1.0 - energy_variance/2.0) + energy_variance * sin(2 * PI * time_elapsed / energy_period))
