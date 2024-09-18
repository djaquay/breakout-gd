extends CanvasLayer

@export var lives: int
var score = 0
var in_game = false
var high_score: int = 0

const HIGH_SCORE_FILE: String = "user://high_score.ini"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ready_to_start_game()
	
	
func ready_to_start_game() -> void:
	$EndText.visible = false
	$StartText.visible = true
	
	score = 0
	$ScoreLabel.text = str(score)
	
	lives = 3
	update_lives()
	
	
func start_game() -> void:
	$StartText.visible = false
	in_game = true


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
	if lives < 1:
		save_high_score()
		reset_game()


func reset_game() -> void:
	$EndText.visible = true
	in_game = false
	$GameOverTimer.start()
	await $GameOverTimer.timeout
	ready_to_start_game()


func load_high_score() -> void:
	if FileAccess.file_exists(HIGH_SCORE_FILE):
		var config := ConfigFile.new()
		config.load(HIGH_SCORE_FILE)

		high_score = config.get_value("player", "high_score")
	else:
		high_score = -1
		score = 0
		save_high_score()
		
	$HSLabel.text = str(high_score)
	
	
func save_high_score() -> void:
	if score > high_score:
		var config := ConfigFile.new()

		config.set_value("player", "high_score", score)

		config.save(HIGH_SCORE_FILE)
		high_score = score
		$HSLabel.text = str(high_score)
