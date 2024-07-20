class_name River

extends StaticBody3D

@onready var path: Path3D = get_node("Path3D")
@onready var path_follow: PathFollow3D = get_node("Path3D/PathFollow3D")

@export var river_resource: Resource

var points: Array = []

var box_ref: DeliveryBox = null

var is_floating_box = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	points = river_resource.points
	# print(points)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if is_floating_box:
		path_follow.progress += 4 * delta
		if path_follow.progress_ratio == 1:
			leave_river()

func calculate_path(box: DeliveryBox):
	var c: Vector3 = box.position
	c.y = 0.2
	print("c position: ", c)
	
	var projected_point = Vector3.ZERO
	var breakpoint_index = 0
	
	for i in range(len(points) - 1):
		var a: Vector3 = points[i]
		var b: Vector3 = points[i+1]
		# print("a: ", a, ", b:", b)
		# print("c position: ", c)
		
		var ab: Vector3 = b - a
		var ac: Vector3 = c - a
		
		# print("ab: ", ab, ", ac: ", ac)
		
		var dotted = ab.dot(ac)
		var mag = ab.dot(ab)
		
		var md = dotted / mag
		
		# print("md: ", md, ", ab * md: ", ab*md)
		
		var proj = a + ab*md
		var proj_diff = (proj - c).length()
		# print("PROJECTION: ", proj, ", DIFF: ", proj_diff)
		# print(proj.length())
		
		if proj_diff < 1:
			# good enough...
			projected_point = proj
			breakpoint_index = i
			break
	
	var curve = Curve3D.new()
	var new_points = points.slice(breakpoint_index+1)
	new_points.insert(0, projected_point)
	for p in new_points:
		curve.add_point(p)
	path.curve = curve
	# print(new_points)
	# print(curve)
	box.position = projected_point
	box.position += Vector3(0, 1, 0) # make box visible
	path_follow.position = projected_point
	box.reparent(path_follow)
	box_ref = box
	is_floating_box = true

func leave_river():
	is_floating_box = false
	box_ref.gravity_scale = 1
