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
	$HUD.lives = 3
	
	
func brick_setup() -> void:
	clear_bricks()
	
	# var size = $Brick/CollisionShape2D.shape.get_rect().size
	for row in range(0, 6):
		for col in range(0, 8):
			var brick = brick_scene.instantiate()
			var size = brick.get_node("ColorRect").size
			brick.position = Vector2(col * (size.x+1) + 50, row * (size.y+1) + 125)
			brick.name = "Brick"
	
			add_child(brick)
			
			
func clear_bricks() -> void:
	get_tree().call_group("bricks", "queue_free")


func _input(event):
	if event is InputEventMouseMotion:
		$Player.position.x = min(max(min_x, event.position.x), max_x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_released("start_game") and not $HUD.in_game:
		start_game()
	if Input.is_action_just_released("cheat_serve") and $HUD.in_game:
		serve_ball()

func start_game() -> void:
	brick_setup()
	$HUD.start_game()
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
	
	ball.left_right = 1 if randi_range(0, 1) > 0 else -1
	ball.up_down = -1  # always starts moving up
	
	ball.brick_hit.connect($HUD.handle_score)
	ball.lost_life.connect(lost_life)
	
	# test seam hit
	# ball.position = Vector2(500, 340)
	# ball.left_right = -1
	
	add_child(ball)


func lost_life() -> void:
	$HUD.handle_lost_life()
	if $HUD.in_game:
		# TODO: add a "get ready, player one" message here?  Or let HUD?
		$ServeTimer.start()
		await $ServeTimer.timeout
		serve_ball()
