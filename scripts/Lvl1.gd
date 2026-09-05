extends Node2D

const LANE1Y = 336
const LANE2Y = LANE1Y + 32
const LANE3Y = LANE2Y + 32
const LANE4Y = LANE3Y + 32
const LANE5Y = LANE4Y + 32

const WLANE1Y = 144
const WLANE2Y = WLANE1Y + 32
const WLANE3Y = WLANE2Y + 32
const WLANE4Y = WLANE3Y + 32
const WLANE5Y = WLANE4Y + 32

# Called when the node enters the scene tree for the first time.
func _ready():
	populateStartingEntities()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func populateStartingEntities():
	var startX
	#car 1
	startX = 384
	for i in 4:
		var car1: PackedScene = load("res://scenes/Car1.tscn")
		var car1Instance: Node2D = car1.instantiate()
		match i:
			1:
				startX = startX - 64
			2:
				startX = startX - 128
			3:
				startX = startX - 64
		car1Instance.setup(Vector2(startX, LANE5Y), -1)
		add_child(car1Instance)
	
	#tractor
	startX = 96
	for i in 3:
		var tractor: PackedScene = load("res://scenes/Tractor.tscn")
		var tractorInstance: Node2D = tractor.instantiate()
		match i:
			1:
				startX = startX + 160
			2:
				startX = startX + 160
		tractorInstance.setup(Vector2(startX, LANE4Y), 1)
		add_child(tractorInstance)	
		
	#car 2
	startX = 384
	for i in 4:
		var car2: PackedScene = load("res://scenes/Car2.tscn")
		var car2Instance: Node2D = car2.instantiate()
		match i:
			1:
				startX = startX - 64
			2:
				startX = startX - 128
			3:
				startX = startX - 64
		car2Instance.setup(Vector2(startX, LANE3Y), -1)
		add_child(car2Instance)	
	
	#car 3	
	startX = 64
	for i in 2:
		var car3: PackedScene = load("res://scenes/Car3.tscn")
		var car3Instance: Node2D = car3.instantiate()
		match i:
			1:
				startX = startX + 64
		car3Instance.setup(Vector2(startX, LANE2Y), 1)
		add_child(car3Instance)	
		
	#truck
	startX = 384
	for i in 3:
		var truck: PackedScene = load("res://scenes/Truck.tscn")
		var truckInstance: Node2D = truck.instantiate()
		match i:
			1:
				startX = startX - 160
			2:
				startX = startX - 160
		truckInstance.setup(Vector2(startX, LANE1Y), -1)
		add_child(truckInstance)	
		
	#turtle twosome
	startX = 384
	for i in 3:
		var turtle: PackedScene = load("res://scenes/Turtle.tscn")
		var turtleInstance: Node2D = turtle.instantiate()
		match i:
			0:
				turtleInstance.setDunker(true)
			1:
				startX = startX - 192
			2:
				startX = startX - 96
		turtleInstance.setup(Vector2(startX, WLANE5Y), -1)
		add_child(turtleInstance)	
	
