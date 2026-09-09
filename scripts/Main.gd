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
	#implement timer
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

var goalCount = 0

signal lvlDied
signal chickenDinner
# Called when the node enters the scene tree for the first time.
func _ready():
	lvl1.process_mode = Node.PROCESS_MODE_DISABLED	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ESC"):
		if lvl1.process_mode == Node.PROCESS_MODE_DISABLED:
			lvl1.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			lvl1.process_mode = Node.PROCESS_MODE_DISABLED
			
	timerBar.value = (frogTimer.time_left / frogTimer.wait_time) * timerBar.max_value
	
	if timerBar.value == 0:
		lvl1.frog.spinOut()
		
func _lvlDied():
	lives.decreaseLife()
	
func _chickenDinner():
	goalCount += 1
	if goalCount == 5:
		lvl1.process_mode = Node.PROCESS_MODE_DISABLED
		UI.visible = true
		UI.setTitleLabel("Winner!")
		UI.setNewGameButtonEnabled(true)

func _game_over():
	goalCount = 0
	lvl1.process_mode = Node.PROCESS_MODE_DISABLED	
	UI.visible = true
	UI.setTitleLabel("Game Over")
	UI.setNewGameButtonEnabled(true)

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
	
	
