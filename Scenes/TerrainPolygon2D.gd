@tool
class_name TerrainPolygon2D extends Polygon2D


func _ready():
	if not Engine.is_editor_hint():
		$StaticBody2D/CollisionPolygon2D.polygon = polygon
	
	$Line2D.points = polygon
	$Line2D.add_point(polygon[0])
	
