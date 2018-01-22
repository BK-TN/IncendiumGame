# GAME class
# Handles really basic things like the background color and switching game state.

extends Node

var Stage = preload("res://gameplay/stage.tscn")
var BossEditor = preload("res://ui/BossEditor.tscn")

# Values for current and target fore- and background colors
# Used for slowly fading into new colors
var bgcol = Color(0,0,0)
var target_bgcol = Color(0.6,0.6,0.6)
var fgcol = Color(0,0,0)
var target_fgcol = Color(1,1,1)

var stage_wr

func _ready():
	set_process_input(true)
	set_process(true)
	
	#var gen = preload("res://gameplay/bosses/BossGenerator.gd").new()
	#start_stage([gen.gen_boss_design(), gen.gen_boss_design(), gen.gen_boss_design(), gen.gen_boss_design(), gen.gen_boss_design()])
	start_editor()

func _process(delta):
	bgcol = bgcol.linear_interpolate(target_bgcol,delta * 3)
	fgcol = fgcol.linear_interpolate(target_fgcol,delta * 0.5)
	get_node("Background/BgEffect").set_modulate(bgcol)
	
func start_stage(bosses):
	var s = Stage.instance()
	s.bosses = bosses
	get_node("Main").add_child(s)
	stage_wr = weakref(s)
	
func start_editor():
	var e = BossEditor.instance()
	get_node("Main").add_child(e)
	
func add_score(num):
	if stage_wr != null:
		var stage = stage_wr.get_ref()
		if stage != null:
			stage.add_score(num)