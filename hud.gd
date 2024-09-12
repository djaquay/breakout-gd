extends CanvasLayer

@export var lives: int
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lives = 3
	update_lives()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func handle_score() -> void:
	score += 10
	$ScoreLabel.text = str(score)
	
	
func update_lives() -> void:
	$LifeLabel.text = str(lives)
	$BallLeft1.visible = lives >= 1
	$BallLeft2.visible = lives >= 2
	$BallLeft3.visible = lives >= 3


func handle_lost_life() -> void:
	lives -= 1
	update_lives()
