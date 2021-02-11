extends Node

signal baby_born(baby)

const BASE_SPECIES_SCENE := preload("res://species/base_species/base_species.tscn")
const BASE_FOOD_SCENE := preload("res://food/base_food/base_food.tscn")

var _grass_tile_positions := PoolVector2Array()

var _food_spawn_rng := Rand.get_new_random_generator()
var _mutation_rng := Rand.get_new_random_generator()

onready var tilemap: TileMap = $TileMap
onready var cell_size := tilemap.cell_size
onready var tile_set: TileSet = tilemap.tile_set
onready var organisms_node: Node = $Organisms
onready var food_node: Node = $Food
onready var hud: CanvasLayer = $HUD

onready var Tiles := {
	"GRASS": tile_set.find_tile_by_name("grass"),
	"TREE": tile_set.find_tile_by_name("tree"),
}


func _ready() -> void:
	for tile in Tiles:
		if Tiles[tile] == -1:
			push_error("The %s tile was not found!" % tile)

	var grass_tiles := tilemap.get_used_cells_by_id(Tiles.GRASS)
	for tile_pos in grass_tiles:
		_grass_tile_positions.append(tilemap.map_to_world(tile_pos))

	for organism in organisms_node.get_children():
		hud.append_population_speed(organism.phenotypes.speed)


func _on_SpawnFood_timeout() -> void:
	var food := BASE_FOOD_SCENE.instance()
	food.position = Rand.choice(_food_spawn_rng, _grass_tile_positions) + cell_size / 2
	food_node.add_child(food)


func make_baby(parent: KinematicBody2D) -> void:
	var baby: KinematicBody2D = load(parent.filename).instance()
	mutate(baby, parent)
	baby.position = parent.position
	assert(baby.connect("baby_wanted", self, "_on_Species_baby_wanted") == OK)
	organisms_node.add_child(baby)
	emit_signal("baby_born", baby)


func mutate(baby: KinematicBody2D, parent: KinematicBody2D) -> void:
	var change := _mutation_rng.randf_range(-50, 50)
	baby.phenotypes.speed = parent.phenotypes.speed + change
	print("Parent Speed: %f  Baby Speed: %f" % [parent.phenotypes.speed, baby.phenotypes.speed])


func _on_Species_baby_wanted(parent: KinematicBody2D) -> void:
	make_baby(parent)


func _on_World_baby_born(baby: KinematicBody2D) -> void:
	hud.append_population_speed(baby.phenotypes.speed)


func _on_Species_dead(organism: KinematicBody2D) -> void:
	hud.erase_population_speed(organism.phenotypes.speed)
