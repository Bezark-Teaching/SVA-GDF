@tool
extends EditorNode3DGizmoPlugin
class_name GaussianSplatGizmoPlugin

const DEFAULT_POINT_SIZE := 2.0
const DEFAULT_COLOR := Color(0.2, 0.8, 1.0)

var _material: StandardMaterial3D

func _init() -> void:
	_material = StandardMaterial3D.new()
	_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_material.albedo_color = DEFAULT_COLOR
	_material.set_flag(BaseMaterial3D.FLAG_USE_POINT_SIZE, true)
	_material.point_size = DEFAULT_POINT_SIZE

func _get_gizmo_name() -> String: return "GaussianSplatNode"
func _get_priority() -> int: return 0
func _has_gizmo(node: Node3D) -> bool: return node is GaussianSplatNode

func _redraw(gizmo: EditorNode3DGizmo) -> void:
	gizmo.clear()
	var node := gizmo.get_node_3d()
	if node == null:
		return
	var gaussian: GaussianResource = node.gaussian
	if gaussian == null:
		return
	var positions: PackedVector3Array = gaussian.xyz
	if positions.is_empty():
		return

	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = positions

	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_POINTS, arrays)
	gizmo.add_mesh(mesh, _material)
