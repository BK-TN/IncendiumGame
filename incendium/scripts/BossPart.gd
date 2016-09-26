
extends Node2D

# Set by Boss
var rot_speed
var color
var max_health
var bullet_size
var bullet_count
var bullet_speed
var shoot_interval
# Health
var health
var health_fade = 0.0
# Shooting
var bullet = preload("res://objects/Bullet.tscn")
var shoot_timer = 1
# Misc
var last_pos

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	get_node("RegularPolygon/Polygon2D").set_color(color)
	health = max_health
	last_pos = get_global_pos()
	
func _process(delta):
	rotate(delta * rot_speed)
	
	if (health_fade > 0):
		health_fade -= delta * 4
		if (health_fade < 0): health_fade = 0
		update()
	
	var velocity = get_global_pos() - last_pos
	last_pos = get_global_pos()
	
	var pos = get_global_pos()
	
	shoot_timer -= delta
	if shoot_timer <= 0 and get_child_count() <= 1:
		for i in range(0,bullet_count):
			var bullet_instance = bullet.instance()
			
			# Calculate bullet direction
			var velocityAngle
			if velocity.x == 0 and velocity.y == 0:
				# Use rotation if no velocity
				velocityAngle = get_rot() * 3
			else:
				velocityAngle = atan2(velocity.y,velocity.x)
			velocityAngle += (i / float(bullet_count)) * PI * 2
			var bulletVelocity = Vector2(cos(velocityAngle),sin(velocityAngle)).normalized() * (bullet_speed)
			
			bullet_instance.velocity = bulletVelocity
			bullet_instance.get_node("RegularPolygon/Polygon2D").set_color(Color(1,1,1).linear_interpolate(color,0.4+6))
			bullet_instance.get_node("RegularPolygon").size = bullet_size
			bullet_instance.get_node("RegularPolygon").remove_from_group("damage_enemy")
			bullet_instance.get_node("RegularPolygon").add_to_group("damage_player")
			bullet_instance.set_pos(get_global_pos())
			get_tree().get_root().add_child(bullet_instance)
			# var angle_towards_center = atan2(pos.x - 720/2, pos.y - 720/2)
			shoot_timer = shoot_interval # + (angle_towards_center * 0.4)
	
func _on_RegularPolygon_area_enter(area):
	if area.get_groups().has("damage_enemy") and get_child_count() <= 1:
		area.get_parent().queue_free()
		health -= 1
		health_fade = 1.0
		if health <= 0:
			queue_free()

func _draw():
	if health_fade > 0:
		var pgon = Vector2Array(get_node("RegularPolygon/Polygon2D").get_polygon())
		var colors = Array()
		for i in range(0,pgon.size()):
			pgon[i] = pgon[i] * (1.0 - float(health) / max_health)
			colors.append(Color(1,1,1,health_fade))
		draw_polygon(pgon,colors)