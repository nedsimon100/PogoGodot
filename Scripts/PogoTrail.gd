extends Line2D

@export var target: Node2D
@export var max_points: int
@export var pointsPerSecond : float

var timeSinceLastPoint : float

func _ready() -> void:
	top_level = true  # ignore parent transform
	global_position = Vector2.ZERO
	rotation = 0.0
	add_point(target.global_position)

func _process(delta: float) -> void:
	timeSinceLastPoint += delta
	set_point_position(0,target.global_position)
	if timeSinceLastPoint >= 1/pointsPerSecond :
		addToTrail()

func addToTrail() -> void:
	timeSinceLastPoint=0
	var pc : int = get_point_count()
	add_point(target.global_position,1)
	if pc > max_points :
		remove_point(pc)
