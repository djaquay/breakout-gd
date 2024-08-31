extends Area2D

@export var hud: Node
var dir
var left_right
var up_down

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	left_right = 1 if randi_range(0, 1) > 0 else -1
	up_down = -1  # always starts moving up
	update_dir()
	
	
func update_dir() -> void:
	# 0deg is right, PI/2 is 90deg, up_down of -1 is up, 1 is down, PI/6 is 30deg
	dir = PI/2 * up_down + PI/6 * left_right


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vel = Vector2(200.0, 0).rotated(dir)
	position += vel * delta
	
