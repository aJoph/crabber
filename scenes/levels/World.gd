class_name GameWorlds
extends Node2D
tool # So editor warnings become enabled.


export(float) var start_game_interval := 3
export(float) var upper_spawn_interval := 3
export(float) var downer_spawn_interval := 3


## How much Player gains for surviving, per second. Defaults to 1. Can be negative.
export(int) var survival_value := 1
export(int) var player_initial_score := 0


export(PackedScene) var upper_scene
export(PackedScene) var downer_scene


var start_timer: Timer
var downer_timer: Timer
var upper_timer: Timer


onready var player := find_node("Player")


func _ready():
	randomize()
	player.survival_gain_rate = survival_value
	player.set_score(player_initial_score)
	
	# Setting up timers.
	start_timer = Timer.new()
	start_timer.wait_time = start_game_interval
	start_timer.one_shot = true
	start_timer.connect("timeout", self, "start_game")
	add_child(start_timer)
	
	downer_timer = Timer.new()
	downer_timer.wait_time = downer_spawn_interval
	downer_timer.connect("timeout", self, "spawn_downer")
	add_child(downer_timer)
	
	upper_timer = Timer.new()
	upper_timer.wait_time = upper_spawn_interval
	upper_timer.connect("timeout", self, "spawn_upper")
	add_child(upper_timer)
	
	new_game()


func new_game() -> void:
	print("new_game")
	player.score = 0
	player.global_position = $StartPosition.global_position
	start_timer.start()


func start_game() -> void:
	print("start_game timeout")
	player.get_node("ScoreTimer").start()
	upper_timer.start()
	downer_timer.start()


## spawn_downer spawns falling objects that either decrease the player's score
## and other negative stuff.
func spawn_downer():
	print("spawn_downer timeout")
	var downer = downer_scene.instance()
	
	downer.global_position.x = rand_range(0, OS.get_real_window_size().x - 50) # 50 arbitrary
	downer.global_position.y = rand_range(10, 50) # arbitrary numbersr
	add_child(downer)


## spawn_upper spawns falling objects that either increase the score of the
## player or are helpful in some other way.
func spawn_upper():
	print("spawn_upper timeout")	
	var upper = upper_scene.instance()
	
	upper.global_position.x = rand_range(0, OS.get_real_window_size().x - 50) # the 50 is arbitrary
	upper.global_position.y = rand_range(10, 80) # arbitrary numbersr
	add_child(upper)


func _get_configuration_warning():
	if get_node_or_null("StartPosition") == null:
		return "A StartPosition (Position2D) node is required."
	
	if upper_scene == null:
		return "Must select a scene to be \"upper\""
	
	if downer_scene == null:
		return "Must select a scene to be \"downer\""
	
	return "" # if nothing's wrong.






