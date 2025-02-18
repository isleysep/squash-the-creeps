extends MeshInstance3D

const MARK_SPACING = 10.0  # Distance between marks
const LINE_WIDTH = 0.2  # Thickness of the marks
const TRACK_LENGTH = 10000.0  # Total length of the ground
const TRACK_WIDTH = 25.0  # Width of the ground

func _ready():
	create_track_with_marks()

func create_track_with_marks():
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Base color for the ground
	var ground_color = Color(0.3, 0.3, 0.3)  # Dark gray
	var mark_color = Color(1, 1, 1)  # White

	# Generate the base ground
	add_quad(surface_tool, Vector3(-TRACK_WIDTH/2, 0, 0), Vector3(TRACK_WIDTH/2, 0, -TRACK_LENGTH), ground_color)

	# Generate marks every 10 meters
	for i in range(0, int(TRACK_LENGTH / MARK_SPACING) + 1):
		var z = -i * MARK_SPACING
		add_quad(surface_tool, Vector3(-TRACK_WIDTH/4, 0.01, z), Vector3(TRACK_WIDTH/4, 0.01, z - LINE_WIDTH), mark_color)

	# Commit mesh
	surface_tool.index()
	var new_mesh = ArrayMesh.new()
	surface_tool.commit(new_mesh)
	mesh = new_mesh

func add_quad(st: SurfaceTool, start: Vector3, end: Vector3, color: Color):
	"""Helper function to create a rectangular quad"""
	st.set_color(color)
	st.add_vertex(start)
	st.add_vertex(Vector3(start.x, start.y, end.z))
	st.add_vertex(end)

	st.add_vertex(end)
	st.add_vertex(Vector3(end.x, start.y, start.z))
	st.add_vertex(start)
