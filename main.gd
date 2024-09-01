extends Node

@export var brick_scene: PackedScene
@export var ball_scene: PackedScene
var min_x
var max_x
var screen_width
var player_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	brick_setup()
	screen_width = $Player.get_viewport_rect().size.x
	
	var wallSize = $LeftWall/CollisionShape2D.shape.get_rect().size
	player_size = $Player/CollisionShape2D.shape.get_rect().size
	min_x = $LeftWall.position.x + 25  # had problems with wallSize not reflecting its scale, so I punted :/
	max_x = $RightWall.position.x - 5 - player_size.x
	
	
func brick_setup() -> void:
	var size = $Brick/CollisionShape2D.shape.get_rect().size
	for row in range(0, 6):
		for col in range(0, 8):
			var brick = brick_scene.instantiate()
			brick.position = Vector2(col * (size.x+1) + 50, row * (size.y+1) + 125)
			brick.name = "Brick"
	
			add_child(brick)


func _input(event):
	if event is InputEventMouseMotion:
		$Player.position.x = min(max(min_x, event.position.x), max_x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_released("serve_ball"):
		serve_ball()


func serve_ball() -> void:
	var ball = ball_scene.instantiate()
	
	# player.get_node("Area2d/CollisionShape2D").shape.radius
	var ballNode = ball.get_node("CollisionShape2D")
	var ballSize = ballNode.shape.get_rect().size
	# var ballX = screen_width / 2 - ballSize.x / 2
	var ballX = $Player.position.x + player_size.x / 2
	var ballY = $Player.position.y - ballSize.y - 5
	ball.position = Vector2(ballX, ballY)
	
	ball.hud = $HUD
	
	add_child(ball)
