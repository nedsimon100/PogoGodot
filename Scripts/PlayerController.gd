extends RigidBody2D

var rotateSpeed : float = 6

var baseGravity : float = 300
var gravityMult : float = 4

var bounceHeight : float = 150
var speedDiv : float = 2.625
var concussedBH : float = 50

var colliding : bool = false
var concussed : bool = false

var recovTime : float = 1

var prevPos : Vector2 = Vector2.INF

@onready var pogoTip : Node2D = $PogoTip 
@onready var pogoTrail : Line2D = $PogoTip/PogoTrail 
@onready var ConcussionTime : Timer = $ConcussTimer
@onready var ConcussionAnimation : AnimatedSprite2D = $ConcussAnim
@onready var BounceAnimation : AnimationPlayer = $BounceAnim
@onready var BounceSnd : AudioStreamPlayer2D = $BounceSound

func _ready() -> void:
	can_sleep = false

func Concuss() -> void:
	concussed = true
	custom_integrator = false
	set_deferred("lock_rotation", false)
	ConcussionTime.start()
	ConcussionAnimation.visible = true
	ConcussionAnimation.play("Concuss")
	await ConcussionTime.timeout
	concussed = false
	custom_integrator = true
	set_deferred("lock_rotation", true)
	ConcussionAnimation.stop()
	ConcussionAnimation.visible = false
	ConcussionTime.stop()
	

var lastVel : Vector2
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	
	if concussed:
		angular_damp = 10-(((ConcussionTime.time_left-recovTime)/ConcussionTime.wait_time)*10)
	# Rotate
	var turn: float = Input.get_axis("rotateLeft", "rotateRight")
	var spin: float = turn-((ConcussionTime.time_left/ConcussionTime.wait_time)*turn)
	state.transform = state.transform.rotated_local(spin * rotateSpeed * state.step)
	
	var currGravity : float
	# Gravity
	if Input.is_action_pressed("Gravity"):
		currGravity = baseGravity*gravityMult
	else: 
		currGravity = baseGravity
	
	var curPos : Vector2 = state.transform * pogoTip.position
	var q := PhysicsRayQueryParameters2D.create(prevPos, curPos)
	q.exclude = [get_rid()]
	q.collision_mask = collision_mask
	var hit := PhysicsServer2D.space_get_direct_state(get_world_2d().space).intersect_ray(q)
	if hit and not colliding:
		var offsetToMove : Transform2D = state.transform
		offsetToMove.origin +=  hit.position - curPos 
		state.transform = offsetToMove
		
	prevPos = state.transform * pogoTip.position
	# Bounce
	if state.get_contact_count() > 0 or hit:
		if not colliding or state.linear_velocity.length() < concussedBH:
			colliding = true
			var speed : float = lastVel.length()
			var dir : Vector2
			if not concussed:
				dir = -state.transform.y
				state.linear_velocity = dir * bounceHeight + (dir * speed/speedDiv)
				BounceAnimation.play("Bounce")
			else:
				var normal : Vector2 
				if state.get_contact_count() > 0:
					normal = state.get_contact_local_normal(0)
				else:
					normal=hit.normal
				dir = lastVel.bounce(normal).normalized()
				state.linear_velocity = dir * concussedBH + (dir * speed/speedDiv)
			pogoTrail.addToTrail()
	else:
		
		colliding = false
		state.linear_velocity += Vector2(0, 1) * currGravity * state.step
		lastVel = state.linear_velocity
