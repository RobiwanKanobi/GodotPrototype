extends Node2D

@onready var sugar_label: Label = $UI/VBoxContainer/SugarLabel
@onready var harvest_btn: Button = $UI/VBoxContainer/SpawnHarvestBtn
@onready var carry_btn: Button = $UI/VBoxContainer/SpawnCarryBtn
@onready var ants_container: Node2D = $Ants
@onready var dropped_berries: Node2D = $DroppedBerries

var harvest_ant_scene: PackedScene = preload("res://ant_hill/harvest_ant.tscn")
var carry_ant_scene: PackedScene = preload("res://ant_hill/carry_ant.tscn")

var sugar: int = 20
var harvest_cost: int = 10
var carry_cost: int = 10

var anthill_position := Vector2(900, 598)
var blueberry_position := Vector2(200, 598)


func _ready() -> void:
	harvest_btn.pressed.connect(_on_spawn_harvest)
	carry_btn.pressed.connect(_on_spawn_carry)
	_update_ui()


func _on_spawn_harvest() -> void:
	if sugar < harvest_cost:
		return
	sugar -= harvest_cost
	harvest_cost += 10
	var ant = harvest_ant_scene.instantiate()
	ant.position = anthill_position
	ant.game = self
	ants_container.add_child(ant)
	_update_ui()


func _on_spawn_carry() -> void:
	if sugar < carry_cost:
		return
	sugar -= carry_cost
	carry_cost += 10
	var ant = carry_ant_scene.instantiate()
	ant.position = anthill_position
	ant.game = self
	ants_container.add_child(ant)
	_update_ui()


func add_sugar(amount: int) -> void:
	sugar += amount
	_update_ui()


func _update_ui() -> void:
	sugar_label.text = "Sugar: %d" % sugar
	harvest_btn.text = "Spawn Harvest Ant (%d)" % harvest_cost
	carry_btn.text = "Spawn Carry Ant (%d)" % carry_cost
	harvest_btn.disabled = sugar < harvest_cost
	carry_btn.disabled = sugar < carry_cost
