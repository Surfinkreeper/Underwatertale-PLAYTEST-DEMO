extends MeshInstance3D

func _ready():
	var surface_array = []
	var tbl = Vector3(-1,1,-1)
	var tbr = Vector3(1,1,-1)
	var tfr = Vector3(1,1,1)
	var tfl = Vector3(-1,1,1)
	var bbl = Vector3(-1,-1,-1)
	var bbr = Vector3(1,-1,-1)
	var bfr = Vector3(1,-1,1)
	var bfl = Vector3(-1,-1,1)

	var vertices = [tbl,tbr,tfl,
					tbr,tfr,tfl,
					bbl,bbr,bfl,
					bbr,bfr,bfl]
					#tfr,tbr,bfr,
					#tbr,bbr,bfr,
					#tbl,tfl,bfl,
					#tbl,bfl,bbl]
	var mesh_name = "middle.tres"
	surface_array.resize(Mesh.ARRAY_MAX)
	
	# PackedVector**Arrays for mesh construction.
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	
	#######################################
	## Insert code here to generate mesh ##
	#######################################
	for i in range(vertices.size()):
		var v = vertices[i]
		var uv
		var normal
		if i < 12:
			uv = Vector2(float(v.x+1)/2,float(v.z+1)/2)
		elif i < 18:
			uv = Vector2(float(-v.z+1)/2,float(-v.y+1)/2) 
		else:
			uv = Vector2(float(v.z+1)/2,float(-v.y+1)/2) 
		if i < 6:
			normal = Vector3(0,1,0)
		elif i < 12:
			normal = Vector3(0,-1,0)
		elif i < 18:
			normal = Vector3(1,0,0)
		else:
			normal = Vector3(-1,0,0)
		verts.append(v)
		uvs.append(uv)
		normals.append(normal)
		indices.append(i)
	# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	
	# Saves mesh to a .tres file with compression enabled.
	ResourceSaver.save(mesh,"res://prototyping/resources/" + mesh_name , ResourceSaver.FLAG_COMPRESS)
	print("Done")
