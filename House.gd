extends Node2D

var sleep_time: bool = false
@onready var sleep_scene_instance: Node2D = $CanvasLayer/ResetScreen
var sleep_scene_timer: float = 0.0

func _ready():
	pass

func _process(delta):
	sleep_scene_timer -= delta
	if Input.is_action_just_pressed("sleep"):
		sleep_scene_instance.visible = true
		sleep_scene_timer = 2.0
		next_night()
	if sleep_scene_timer <= 0.0:
		sleep_scene_instance.visible = false
		sleep_time = false

func next_night():
	sleep_time = true
	for node in get_children():
		if node.has_method("do_reset"):
			node.do_reset()
