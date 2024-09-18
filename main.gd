extends Node

@export var brick_scene: PackedScene
@export var ball_scene: PackedScene
var min_x
var max_x
var screen_width
var player_size
var ball


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	brick_setup()
	screen_width = $Player.get_viewport_rect().size.x
	
	var wallSize = $LeftWall/CollisionShape2D.shape.get_rect().size
	player_size = $Player/CollisionShape2D.shape.get_rect().size
	min_x = $LeftWall.position.x + 25  # had problems with wallSize not reflecting its scale, so I punted :/
	max_x = $RightWall.position.x - 5 - player_size.x
	$HUD.lives = 3
	$HUD.load_high_score()
	
	
func brick_setup() -> void:
	clear_bricks()
	
	# var size = $Brick/CollisionShape2D.shape.get_rect().size
	for row in range(0, 6):
		for col in range(0, 8):
			add_brick(row, col)
			
	# test level reset
	# clear_bricks()
	# add_brick(3, 3)
			
func add_brick(row, col) -> void:
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
	ball = ball_scene.instantiate()
	
	ball.brick_hit.connect($HUD.handle_score)
	ball.brick_hit.connect(_on_brick_hit)
	ball.lost_life.connect(lost_life)
	
	# test seam hit
	# ball.position = Vector2(500, 340)
	# ball.left_right = -1
	
	ball_serve_position()
	
	add_child(ball)
	
	
func ball_serve_position() -> void:
	var ballX = $Player.position.x + player_size.x / 2
	var ballY = $Player.position.y - 25
	ball.position = Vector2(ballX, ballY)
	
	ball.left_right = 1 if randi_range(0, 1) > 0 else -1
	ball.up_down = -1  # always starts moving up
	
	# test dir
	# ball.left_right = 1  # left
	
	ball.update_dir()
	

func lost_life() -> void:
	$HUD.handle_lost_life()
	if $HUD.in_game:
		# TODO: add a "get ready, player one" message here?  Or let HUD?
		$ServeTimer.start()
		await $ServeTimer.timeout
		serve_ball()


func _on_brick_hit() -> void:
	$HitTimer.start()
	await $HitTimer.timeout
	
	var bricks: Array = get_tree().get_nodes_in_group("bricks")
	if bricks.size() <= 0:
		ball_serve_position()
		brick_setup()
