extends RigidBody2D

var RotateSpeed : float = 10
var bouncePower : float = 10
var GravityMult : float = 5
@onready var ConcussionTime : Timer = $ConcussTimer
@onready var ConcussionAnimation : AnimatedSprite2D = $ConcussAnim
@onready var BounceAnimation : AnimationPlayer = $BounceAnim
@onready var BounceSnd : AudioStreamPlayer2D = $BounceSound

func Concuss() -> void:
	ConcussionTime.start()
	ConcussionAnimation.visible = true
	ConcussionAnimation.play("Concuss")
	await ConcussionTime.timeout
	ConcussionAnimation.stop()
	ConcussionAnimation.visible = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Rotate
	var turn: float = Input.get_axis("rotateLeft", "rotateRight")
	state.transform = state.transform.rotated_local(turn * RotateSpeed * state.step)
	# Gravity
	if Input.is_action_pressed("Gravity"):
		gravity_scale = GravityMult
	else: 
		gravity_scale = 1
	# Bounce
	if state.get_contact_count() > 0 and ConcussionTime.is_stopped():
		BounceAnimation.play("Bounce")
		BounceSnd.play()
		var speed: float = state.linear_velocity.length()
		state.linear_velocity = transform.y * -speed
	elif not ConcussionTime.is_stopped():
	# Concussed
		angular_damp = 100-((ConcussionTime.time_left/ConcussionTime.wait_time)*100)
