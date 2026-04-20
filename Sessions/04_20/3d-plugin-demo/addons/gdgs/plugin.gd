@tool
extends EditorPlugin

const MANAGER_NODE_NAME := "_GdgsGaussianRenderManager"
const DIRECT_TEXTURE_OVERLAY_NAME := "_GdgsDirectTextureOverlay"

var import_plugin: EditorImportPlugin
var gizmo_plugin: EditorNode3DGizmoPlugin

func _enter_tree() -> void:
	import_plugin = preload("res://addons/gdgs/importers/gaussian_import_plugin.gd").new()
	add_import_plugin(import_plugin)

	gizmo_plugin = preload("res://addons/gdgs/editor/gizmos/gaussian_splat_gizmo_plugin.gd").new()
	add_node_3d_gizmo_plugin(gizmo_plugin)

	print("[gdgs] enable gaussian splatting plugin")

func _exit_tree() -> void:
	if import_plugin != null:
		remove_import_plugin(import_plugin)
	if gizmo_plugin != null:
		remove_node_3d_gizmo_plugin(gizmo_plugin)

	var tree := get_tree()
	if tree != null and tree.root != null:
		var manager := tree.root.get_node_or_null(MANAGER_NODE_NAME)
		if manager != null:
			if manager.has_method("shutdown"):
				manager.shutdown()
			manager.queue_free()

		var direct_texture_overlay := tree.root.get_node_or_null(DIRECT_TEXTURE_OVERLAY_NAME)
		if direct_texture_overlay != null:
			direct_texture_overlay.queue_free()

	print("[gdgs] disable gaussian splatting plugin")
