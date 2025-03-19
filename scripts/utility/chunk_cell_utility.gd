class_name ChunkCellUtility

static var chunk_size : Vector2i = Vector2i(10, 10)

static func get_chunk(cell_coords : Vector2i) -> Vector2i: #Get chunk coordinates from cell coordinates
	return Vector2i(floor(cell_coords.x / float(chunk_size.x)), floor(cell_coords.y / float(chunk_size.y))) #Int division will work wrong with negative coordinates I think

static func get_cell(chunk_coords : Vector2i, global_cell_coords : Vector2i) -> Vector2i: #Get local cell coordinates from chunk coordinates
	return global_cell_coords - (chunk_coords * chunk_size)

static func get_global(chunk_coords : Vector2i, local_cell_coords : Vector2i) -> Vector2i: #Get global cell coordinates from chunk coordinates
	return (chunk_coords * chunk_size) + local_cell_coords

static func check_inbounds_local(local_cell_coords : Vector2i) -> bool:
	return local_cell_coords.x >= 0 and local_cell_coords.x < chunk_size.x and local_cell_coords.y >= 0 and local_cell_coords.y < chunk_size.y