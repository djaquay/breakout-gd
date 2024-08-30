extends Node

@export var brick_scene: PackedScene
var min_x
var max_x


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	brick_setup()
	
	var wallSize = $LeftWall/CollisionShape2D.shape.get_rect().size
	var playerSize = $Player/CollisionShape2D.shape.get_rect().size
	min_x = $LeftWall.position.x + 25  # had problems with wallSize not reflecting its scale, so I punted :/
	max_x = $RightWall.position.x - 5 - playerSize.x
	
	
func brick_setup() -> void:
	var size = $Brick/CollisionShape2D.shape.get_rect().size
	for row in range(0, 6):
		for col in range(0, 8):
			var brick = brick_scene.instantiate()
			brick.position = Vector2(col * (size.x+1) + 50, row * (size.y+1) + 125)
	
			add_child(brick)


func _input(event):
	if event is InputEventMouseMotion:
		$Player.position.x = min(max(min_x, event.position.x), max_x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
