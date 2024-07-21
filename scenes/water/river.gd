class_name River

extends StaticBody3D

@onready var path: Path3D = get_node("Path3D")
@onready var path_follow: PathFollow3D = get_node("Path3D/PathFollow3D")
@onready var path_2: Path3D = get_node("Path3D2")
@onready var path_follow_2: PathFollow3D = get_node("Path3D2/PathFollow3D")

@export var river_resource: Resource

var points: Array = []

var box_ref: DeliveryBox = null
var box_ref_2: DeliveryBox = null

var is_floating_box = false
var is_floating_box_2 = false

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
			leave_river(box_ref)
	if is_floating_box_2:
		path_follow_2.progress += 4 * delta
		if path_follow_2.progress_ratio == 1:
			leave_river(box_ref_2)

func calculate_path(box: DeliveryBox):
	var c: Vector3 = box.position
	c.y = 0.1
	# print("c position: ", c)
	# print(c)
	var projected_point = Vector3.ZERO
	var breakpoint_index = 0
	
	if not is_floating_box:
		path_follow.progress = 0 # reset incase its not already 0
	else:
		path_follow_2.progress = 0
	
	var projs = []
	var proj_diffs = []
	
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
		
		projs.append(proj)
		proj_diffs.append(proj_diff)
	
	var min_diff = proj_diffs.min()
	var min_diff_i = proj_diffs.find(min_diff)

	projected_point = projs[min_diff_i]
	breakpoint_index = min_diff_i

	var curve = Curve3D.new()
	var new_points = points.slice(breakpoint_index+1)
	new_points.insert(0, projected_point)
	for p in new_points:
		curve.add_point(p)
	# print(new_points)
	# print(curve)
	box.position = projected_point
	box.position += Vector3(0, 1, 0) # make box visible
	if not is_floating_box:
		# print("setting box_ref")
		path.curve = curve
		path_follow.position = projected_point
		box.reparent(path_follow)
		box_ref = box
		box.river_ref = self
		is_floating_box = true
	else: # there already is a floating box
		path_2.curve = curve
		path_follow_2.position = projected_point
		box.reparent(path_follow_2)
		box_ref_2 = box
		box.river_ref = self
		is_floating_box_2 = true

func leave_river(box: DeliveryBox):
	call_deferred("deferred_leave_river", box)

func deferred_leave_river(box: DeliveryBox):
	# print("leaving river: ", self)
	if box == box_ref:
		# print("resetting box_ref")
		is_floating_box = false
		box_ref.river_ref = null
		box_ref.freeze = false
		box_ref.in_river = false
		box_ref.gravity_scale = 1
		if box_ref.is_heavy:
			box_ref.reparent(get_parent())
		box_ref = null
		# path.curve = null
	elif box == box_ref_2:
		is_floating_box_2 = false
		box_ref_2.river_ref = null
		box_ref_2.freeze = false
		box_ref_2.in_river = false
		box_ref_2.gravity_scale = 1
		if box_ref_2.is_heavy:
			box_ref_2.reparent(get_parent())
		box_ref_2 = null
