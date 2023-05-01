class_name Tail extends Node2D

var tail_point = preload("res://Scenes/Tail Point.tscn")
var tail_link = preload("res://Scenes/Tail Link.tscn")
var points: Array = []
var links: Array = []
@onready var line_2d = $Line2D

@export var length: int = 5

var done = false

func _ready():
	regenerate()

func _physics_process(_delta):
	var line_points = PackedVector2Array()
	line_points.append(Vector2.ZERO)
	for point in points:
		line_points.append(to_local(point.global_position))
	line_2d.points = line_points
	
func add_point(parent: Node2D):
	var point: RigidBody2D = tail_point.instantiate()
	if parent.has_meta("tail_point"):
		point.position = parent.position
		point.position.x -= 4
	else:
		point.position = Vector2(0, 0)
		print(point.position)
	add_child(point)
	points.append(point)
	return point

func add_link(parent, child):
	var link: PinJoint2D = tail_link.instantiate()
	link.node_a = parent.get_path()
	link.node_b = child.get_path()
	parent.add_child.call_deferred(link)
	links.append(link)

func regenerate():
	for point in points:
		point.queue_free()
	for link in links:
		link.queue_free()
	
	points.clear()
	links.clear()
	
	if done:
		done = !done
		return
		
	var parent = get_parent()
	for i in range(length):
		var child = add_point(parent)
		add_link(parent, child)
		parent = child
	
	done = true
