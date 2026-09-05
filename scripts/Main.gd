extends Node2D

#MAIN TODO LIST:

		#implement vehicles collisions
		#truck honk?
	#art for crocs
		#implement crocs
	#art for snake
		#implement snake
	#art for turtles
		#implement turtles
	#art for flies
		#implement flies 
		#score
	#implement timer
	#implement lives
		#death animations
		#1up
	#implement menu
	#implement music/sound effects
	#implement input buffer


@onready var lives: Lives = $Lives
@onready var lvl1: Lvl1 = $Lvl1

signal lvlDied

# Called when the node enters the scene tree for the first time.
func _ready():
	lives.gameOver.connect(_game_over)
	lvl1.lvlDied.connect(_lvlDied)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _lvlDied():
	lives.decreaseLife()
	
func _game_over():
	print("Game Over")
