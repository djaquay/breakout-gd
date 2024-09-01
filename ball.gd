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
	# 0deg is right, PI/2 is 90deg, up_down of -1 is up, 1 is down, PI/6 is 30deg, 1 is right?
	dir = PI/2 * up_down + PI/6 * left_right * up_down


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vel = Vector2(200.0, 0).rotated(dir)
	position += vel * delta
	


func _on_area_entered(area: Area2D) -> void:
	var other:String = area.name
	if other.contains("TopWall"):
		up_down *= -1
	elif other.contains("Wall"):
		left_right *= -1
	elif other.contains("Player"):
		up_down *= -1
	elif area in get_tree().get_nodes_in_group("bricks"):
		area.queue_free()
		up_down *= -1
	update_dir()
