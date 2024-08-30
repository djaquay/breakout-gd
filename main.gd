extends Node

@export var brick_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	brick_setup()
	
	
func brick_setup() -> void:
	var size = $Brick/CollisionShape2D.shape.get_rect().size
	for row in range(0, 6):
		for col in range(0, 8):
			var brick = brick_scene.instantiate()
			brick.position = Vector2(col * (size.x+1) + 50, row * (size.y+1) + 125)
	
			add_child(brick)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
