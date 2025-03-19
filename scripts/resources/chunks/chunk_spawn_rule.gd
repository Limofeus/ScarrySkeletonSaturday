extends Resource
class_name ChunkSpawnRule

#Maybe store prefab of chunk here later as well? Tho I'll have to find a more efficient way to load it (maybe using megachunks/chunk_clusters)

func _use_this_rule(chunk_coords : Vector2i) -> bool:
	return false

func _generate_chunk_data(random_hash_increment : int, chunk_coords : Vector2i) -> ChunkData:
	return null #Should return NEW chunk data :)