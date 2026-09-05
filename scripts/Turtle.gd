extends MovingElement
class_name Turtle

@onready var frameTimer: Timer = $FrameTimer
@onready var dunkTimer: Timer = $DunkTimer

@onready var TurtleSprite: Sprite2D = $TurtleSprite
@onready var TurtleArea: Area2D = $TurtleSprite/TurtleArea
@onready var TurtleSprite2: Sprite2D = $TurtleSprite2
@onready var TurtleArea2: Area2D = $TurtleSprite2/TurtleArea
@onready var TurtleSprite3: Sprite2D = $TurtleSprite3
@onready var TurtleArea3: Area2D = $TurtleSprite3/TurtleArea

const SPEED = 100

var frame
var isDunker 
var isDunking
var reverseDunking
var finishedDunking: bool = true
var dunkZone

# Called when the node enters the scene tree for the first time.
func _ready():
	frameTimer.start()
	#dunkTimer.start() #changing to use collission instead of timer
	frame = 0
	super.setSpeed(SPEED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func _physics_process(delta):
	match frame:
		0, 1, 2, 3:
			TurtleArea.set_deferred("collision_layer", 1)
			TurtleArea2.set_deferred("collision_layer", 1)
			TurtleArea3.set_deferred("collision_layer", 1)
		4, 5:
			TurtleArea.set_deferred("collision_layer", 0)
			TurtleArea2.set_deferred("collision_layer", 0)
			TurtleArea3.set_deferred("collision_layer", 0)
	

func setDunker(dunker, setDunkZone):
	isDunker = dunker
	dunkZone = setDunkZone
	
func turnOff3rdTurtle():
	TurtleSprite3.visible = false
	TurtleArea3.collision_layer = 0
	TurtleArea3.collision_mask = 0

func _on_frame_timer_timeout():
	if isDunker and isDunking and !reverseDunking:
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
				finishedDunking = true
				isDunking = false
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
	TurtleSprite3.frame = frame

func _on_dunk_timer_timeout():
	pass #startDunking()
	
func startDunking():
	if isDunker and finishedDunking:
		isDunking = true
		reverseDunking = false
		


func _on_turtle_area_area_entered(area):
	var collisionArea: Area2D = area
	#print (collisionArea.name)
	match collisionArea.name:
		"DunkZone1":
			if dunkZone == 1:
				startDunking()
		"DunkZone2":
			if dunkZone == 2:
				startDunking()
