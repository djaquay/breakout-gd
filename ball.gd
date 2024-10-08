extends Area2D

signal brick_hit
signal lost_life

@export var left_right: int
@export var up_down: int
var dir
var last_brick_hit = 0
var speed = 200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_dir()
	
	
func update_dir() -> void:
	# 0deg is right, PI/2 is 90deg, up_down of -1 is up, 1 is down, PI/6 is 30deg, 1 is right?
	dir = PI/2 * up_down + PI/6 * left_right * up_down


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vel = Vector2(speed, 0).rotated(dir)
	position += vel * delta


func _on_area_entered(area: Area2D) -> void:
	var other:String = area.name
	if other.contains("TopWall"):
		up_down *= -1
	elif other.contains("Wall"):
		left_right *= -1
	elif other.contains("Player"):
		up_down *= -1
	elif Time.get_ticks_msec() > last_brick_hit and area in get_tree().get_nodes_in_group("bricks"):
		area.queue_free()
		brick_hit.emit()
		up_down *= -1
		speed += 5
		last_brick_hit = Time.get_ticks_msec()
	update_dir()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	lost_life.emit()
