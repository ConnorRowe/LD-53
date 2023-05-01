@tool
class_name Rail extends Line2D


@export var height: float = 20

var length: float

func _ready():
	make_polygon()

func make_polygon():
	var points_copy = points.duplicate()
	var h = Vector2(0, height)
	
	for i in range(len(points)-1, -1, -1):
		points_copy.append(points_copy[i] + h)
		
	$StaticBody2D/CollisionPolygon2D.polygon = points_copy
	
	length = 0.0
	for i in range(get_point_count() - 2):
		length += get_point_position(i).distance_to(get_point_position(i + 1))
	
	$StaticBody2D/CollisionPolygon2D.one_way_collision = false
	

func _on_visibility_changed():
	if Engine.is_editor_hint():
		make_polygon()

func find_percent_at_position(global_pos: Vector2):
	var local_x = to_local(global_pos).x
	var start = -1
	var end = -1
	for i in range(get_point_count() - 1):
		if get_point_position(i).x >= local_x:
			end = i
			start = maxi(i-1, 0)
			break
	
	if end == -1:
		end = get_point_count() - 1
		start = end - 1
	elif start < 0:
		return 0.0
	
	var inbetween_points = inverse_lerp(get_point_position(start).x, get_point_position(end).x, local_x)

	return clampf((float(start) / float(get_point_count() - 1)) + (inbetween_points / get_point_count()), 0.0, 1.0)

func is_rail_below_position(global_pos: Vector2):
	var p = (get_point_count() - 1) * find_percent_at_position(global_pos)
	var floored = floori(p)
	var remainder = p - floored
	var point_a = get_point_position(floored)
	var point_b = get_point_position(mini(floored + 1, get_point_count() - 1))
	var lerped = lerp(point_a, point_b, remainder)
	print("is_rail_below_position: ", lerped.y > to_local(global_pos).y, " (", lerped.y, " < ", to_local(global_pos).y, ")")
	return lerped.y > to_local(global_pos).y
