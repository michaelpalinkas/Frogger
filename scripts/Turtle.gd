extends MovingElement
class_name Turtle

@onready var frameTimer: Timer = $FrameTimer
@onready var dunkTimer: Timer = $DunkTimer
@onready var TurtleSprite: Sprite2D = $TurtleSprite
@onready var TurtleSprite2: Sprite2D = $TurtleSprite2

const SPEED = 100

var frame
var isDunker 
var isDunking
var reverseDunking

# Called when the node enters the scene tree for the first time.
func _ready():
	frameTimer.start()
	dunkTimer.start()
	frame = 0
	super.setSpeed(SPEED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)


func setDunker(dunker):
	isDunker = dunker

func _on_frame_timer_timeout():
	if isDunker and isDunking:
		match frame:
			0:
				frame = 3 
			3:
				frame = 4
			4:
				frame = 5
				reverseDunking = true
	elif isDunker and reverseDunking:
		match frame:
			5:
				frame = 4
			4:
				frame = 3
			3:
				frame = 0
				reverseDunking = false
	else:
		match frame:
			0:
				frame = 1
			1:
				if !isDunking:
					frame = 2
			2:
				if !isDunking:
					frame = 0
				
	TurtleSprite.frame = frame
	TurtleSprite2.frame = frame

func _on_dunk_timer_timeout():
	if isDunker:
		if !isDunking:
			reverseDunking = false
		isDunking = !isDunking
		
