extends Node2D

#MAIN TODO LIST:

	#fix double drown bug fixxed?
	#diagonal bug after getting to end
	#left stuck bug
	#art for crocs
		#implement crocs
	#art for snake
		#implement snake
	#art for flies
		#implement flies 
		#score
		#1up
	#implement music/sound effects
		#truck honk?
	#random exhaust animation
	#implement input buffer

@onready var UI: CanvasLayer = $"../../UI"
@onready var lives: Lives = $Lives
@onready var lvl1: Lvl1 = $Lvl1
@onready var timerBar: TextureProgressBar = $"../PanelContainer2/HBoxContainer/TimerBar"
@onready var frogTimer: Timer = $"../FrogTimer"
@onready var scoreLabel: Label = $"../PanelContainer/VBoxContainer/Score"
@onready var hiScoreLabel: Label = $"../PanelContainer3/VBoxContainer/HiScore"

const SAVEPATH = "user://froggerHighScore.tres"

var goalCount: int = 0
var score: int = 0
var displayScore: String = ""
var currentTimeLeft: int
var displayHiScore: String = ""
var hiScore: int

signal lvlDied
signal chickenDinner
# Called when the node enters the scene tree for the first time.
func _ready():
	lvl1.process_mode = Node.PROCESS_MODE_DISABLED		
	currentTimeLeft = int(timerBar.max_value)
	loadScore()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ESC"):
		if lvl1.process_mode == Node.PROCESS_MODE_DISABLED:
			lvl1.process_mode = Node.PROCESS_MODE_INHERIT
			frogTimer.paused = false
		else:
			lvl1.process_mode = Node.PROCESS_MODE_DISABLED
			frogTimer.paused = true
			
	timerBar.value = (frogTimer.time_left / frogTimer.wait_time) * timerBar.max_value
	
	if timerBar.value == 0:
		lvl1.frog.spinOut()
	
	scoreLabel.text = _getDisplayScore()
	hiScoreLabel.text = _getDisplayHiScore()
		

func saveScore(newScore: int):
	var data: SaveData
	if ResourceLoader.exists(SAVEPATH):
		data = ResourceLoader.load(SAVEPATH)
	else:
		data = SaveData.new()
	
	print(str(newScore) + " " + str(data.highScore))
	if newScore > data.highScore:
		data.highScore = newScore
		var error = ResourceSaver.save(data, SAVEPATH)
		if error:
			print(error)
	
func loadScore():
	if ResourceLoader.exists(SAVEPATH):
		var data = ResourceLoader.load(SAVEPATH) as SaveData
		if data:
			hiScore = data.highScore

func _lvlDied():
	lives.decreaseLife()
	frogTimer.start()
	
func _frogUpMove():
	score += 10
	
func _getDisplayScore() -> String:
	displayScore = str(score)
	displayScore = displayScore.lpad(5, "0")
	return displayScore

func _getDisplayHiScore() -> String:
	displayHiScore = str(hiScore)
	displayHiScore = displayHiScore.lpad(5, "0")
	return displayHiScore

func _chickenDinner():
	goalCount += 1
	score += 50
	currentTimeLeft = int(timerBar.value) #casting to int to truncate
	score += int(10 * currentTimeLeft)
			
	frogTimer.start()
	if goalCount == 5:
		score += 1000
		lvl1.process_mode = Node.PROCESS_MODE_DISABLED
		UI.visible = true
		UI.setTitleLabel("Winner!")
		UI.setNewGameButtonEnabled(true)
		saveScore(score)
		loadScore()
		score = 0
		frogTimer.paused = true

func _game_over():
	goalCount = 0
	lvl1.process_mode = Node.PROCESS_MODE_DISABLED	
	UI.visible = true
	UI.setTitleLabel("Game Over")
	UI.setNewGameButtonEnabled(true)
	saveScore(score)
	score = 0
	frogTimer.paused = true

func _on_new_game_button_pressed():
	lvl1.process_mode = Node.PROCESS_MODE_INHERIT
	UI.visible = false
	UI.setNewGameButtonEnabled(false)
	if is_instance_valid(lvl1):
		lvl1.queue_free()
	var lvlPacked = load("res://scenes/Lvl1.tscn")
	lvl1 = lvlPacked.instantiate()
	add_child(lvl1)
	var livesPos
	if is_instance_valid(lives):
		livesPos = lives.position
		lives.queue_free()
	var livesPacked = load("res://scenes/Lives.tscn")
	lives = livesPacked.instantiate()
	lives.position = livesPos
	add_child(lives)
	connectSignals()
	frogTimer.start()

func connectSignals():
	lives.gameOver.connect(_game_over)
	lvl1.lvlDied.connect(_lvlDied)
	lvl1.fireChickenDinner.connect(_chickenDinner)
	lvl1.frogUpMove.connect(_frogUpMove)
	
	
