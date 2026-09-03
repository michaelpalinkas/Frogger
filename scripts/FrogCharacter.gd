extends Node2D

@onready var frog: Node2D = $"."
@onready var frogSprite: Sprite2D = $FrogSprite
@onready var processingmove: bool = false
@onready var destinationX: int = -1
@onready var destinationY: int = -1


const SPEED = 200
const MOVE_LENGTH = 32
const FRAME_STOPPED = 0
const FRAME_JUMPING = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("LEFT"):
		if processingmove == false:
			processingmove = true		
			frogSprite.rotation_degrees = -90
			destinationX = frog.position.x - MOVE_LENGTH
	
	if Input.is_action_just_pressed("RIGHT"):
		if processingmove == false:
			processingmove = true		
			frogSprite.rotation_degrees = 90
			destinationX = frog.position.x + MOVE_LENGTH
		
	if Input.is_action_just_pressed("UP"):
		if processingmove == false:
			processingmove = true		
			frogSprite.rotation_degrees = 0
			destinationY = frog.position.y - MOVE_LENGTH
	
	if Input.is_action_just_pressed("DOWN"):
		if processingmove == false:
			processingmove = true		
			frogSprite.rotation_degrees = 180
			destinationY = frog.position.y + MOVE_LENGTH
		
	if processingmove == true:
		frogSprite.frame = FRAME_JUMPING
		if destinationX != -1 and frog.position.x > destinationX: #left
			frog.position.x = frog.position.x - (delta * SPEED)
			if frog.position.x <= destinationX:
				frog.position.x = destinationX
				processingmove = false
				destinationX = -1
		if destinationX != -1 and frog.position.x < destinationX: #right
			frog.position.x = frog.position.x + (delta * SPEED)
			if frog.position.x >= destinationX:
				frog.position.x = destinationX
				processingmove = false
				destinationX = -1
		if destinationY != -1 and frog.position.y > destinationY: #up
			frog.position.y = frog.position.y - (delta * SPEED)
			if frog.position.y <= destinationY:
				frog.position.y = destinationY
				processingmove = false
				destinationY = -1
		if destinationY != -1 and frog.position.y < destinationY: #down
			frog.position.y = frog.position.y + (delta * SPEED)
			if frog.position.y >= destinationY:
				frog.position.y = destinationY
				processingmove = false
				destinationY = -1
	else:
		frogSprite.frame = FRAME_STOPPED
		
