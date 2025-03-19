extends ChunkSpawnRule
class_name BoxChunkSpawnRule

@export var mines_per_chunk : int = 10 #10-easy
@export var top_left_coords : Vector2i = Vector2i(0, 0) #Inclusive
@export var bottom_right_coords : Vector2i = Vector2i(0, 0) #Inclusive

func _use_this_rule(chunk_coords : Vector2i) -> bool:
	return (chunk_coords.x >= top_left_coords.x and chunk_coords.y >= top_left_coords.y and chunk_coords.x <= bottom_right_coords.x and chunk_coords.y <= bottom_right_coords.y)

func _generate_chunk_data(random_hash_increment : int, chunk_coords : Vector2i) -> ChunkData:
	var new_chunk_data = ChunkData.new()
	new_chunk_data.generate_chunk(random_hash_increment, chunk_coords, mines_per_chunk)
	return new_chunk_data