extends Resource
class_name ChunkData

#No need to store chunk pos here, as chunk datas will be stored in pos->data dictionary

const chunk_size : Vector2i = Vector2i(10, 10) #In cells (Also not sure if x and y should be swapped, but it works either way for square chunks)

var chunk_mines : Array = [] #Nested array of bools, so cant declare explicitly
var uncovered_cell_values : Array = [] #Also nested used to determine both wether cell is covered or not and amount of mines near cell (-1 - covered, 0 - no mines, 1 - 8 mines)
var _chunk_pos : Vector2i = Vector2i(0, 0)

var propagation_cell_queue : Array[Vector2i] = []

signal on_cell_uncovered(cell_coords : Vector2i)

func init_mine_array() -> void:
	for i in range(chunk_size.x):
		var mines_row : Array = []
		var coverage_row : Array = []
		for j in range(chunk_size.y):
			mines_row.append(false)
			coverage_row.append(-1)
		chunk_mines.append(mines_row)
		uncovered_cell_values.append(coverage_row)

func generate_chunk(hash_increment : int, chunk_pos : Vector2i, mine_amount : int) -> void: #Pos here is used as a hash for random map generation
	init_mine_array()

	_chunk_pos = chunk_pos

	var generation_hash : int = hash(chunk_pos) + hash_increment
	var rng = RandomNumberGenerator.new()
	rng.seed = generation_hash

	#This should be optimized for large amounts of mines
	var possible_mine_positions : Array[Vector2i] = []

	for i in range(chunk_size.x):
		for j in range(chunk_size.y):
			possible_mine_positions.append(Vector2i(i, j))

	for i in range(mine_amount):
		var random_mine_pos : Vector2i = possible_mine_positions[rng.randi_range(0, possible_mine_positions.size() - 1)]

		possible_mine_positions.erase(random_mine_pos)
		chunk_mines[random_mine_pos.x][random_mine_pos.y] = true

func is_covered(cell_coords : Vector2i) -> bool:
	return uncovered_cell_values[cell_coords.x][cell_coords.y] == -1

func is_mine(cell_coords : Vector2i) -> bool:
	#Just checks local chunk
	return chunk_mines[cell_coords.x][cell_coords.y]

func mine_check(cell_coords : Vector2i) -> bool:
	#Slower, but can check adjacent chunks utilizing chunk manager, input is still local coords e.g: (-1, 0), (10, -3) etc.
	if ChunkCellUtility.check_inbounds_local(cell_coords):
		return is_mine(cell_coords)
	else:
		return ChunkManager.instance.global_mine_check(ChunkCellUtility.get_global(_chunk_pos, cell_coords))

func propagate_uncover_cell(cell_coords : Vector2i, force_propagation_depth : int, propagation_timer : Timer) -> void:
	
	var initial_propagation_queue_size = propagation_cell_queue.size()

	uncover_cell(cell_coords, true)

	if initial_propagation_queue_size > 0:
		#If queue WAS not empty there's probably another propagator already running (tho there might be a bug in case there is not), so we shouldn't start another one
		#Also we do it after uncovering a cell
		return

	while propagation_cell_queue.size() > 0:
		await propagation_timer.timeout

		var step_propagation_buffer = propagation_cell_queue.duplicate()
		for cell_to_propagate in step_propagation_buffer:
			propagation_cell_queue.erase(cell_to_propagate)

			for i in range(-1, 2):
				for j in range(-1, 2):
					if i != 0 or j != 0:
						var propagation_uncover_vector = cell_to_propagate + Vector2i(i, j)
						if ChunkCellUtility.check_inbounds_local(propagation_uncover_vector):
							uncover_cell(propagation_uncover_vector, true)
						else:
							#print("Propagating to other chunk at fp_depth: " + str(force_propagation_depth))
							ChunkManager.instance.uncover_cell(ChunkCellUtility.get_global(_chunk_pos, propagation_uncover_vector), force_propagation_depth, propagation_timer)


func uncover_cell(cell_coords : Vector2i, append_to_propagation_queue : bool = false) -> void:

	if uncovered_cell_values[cell_coords.x][cell_coords.y] != -1:
		#print("Cell is already uncovered: " + str(cell_coords))
		return

	uncovered_cell_values[cell_coords.x][cell_coords.y] = nearby_mines(cell_coords)
	on_cell_uncovered.emit(cell_coords)
	if append_to_propagation_queue and uncovered_cell_values[cell_coords.x][cell_coords.y] == 0:
		propagation_cell_queue.append(cell_coords)
	#print("Cell uncovered: " + str(cell_coords) + " Nearby mines: " + str(uncovered_cell_values[cell_coords.x][cell_coords.y]))

func nearby_mines(cell_coords : Vector2i) -> int:
	var mines_nearby : int = 0
	for i in range(-1, 2):
		for j in range(-1, 2):
			if i != 0 or j != 0:
				var mine_check_vector = cell_coords + Vector2i(i, j)

				if mine_check(mine_check_vector):
					mines_nearby += 1
	return mines_nearby
