import 'dart:io';
import 'dart:math';

import 'package:ar_flutter_plugin_engine/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_engine/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:path_provider/path_provider.dart';

class TryOnGlassesController extends GetxController {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARNode? faceNode;
  final isLoading = false.obs;

  // Call this from the AR view created callback
  void onARViewCreated(ARSessionManager sessionManager, ARObjectManager objectManager) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    // Configure session for face tracking
    arSessionManager?.onInitialize(
      showFeaturePoints: false,
      showPlanes: false,
      customPlaneTexturePath: null,
      showWorldOrigin: false,
      handleTaps: false,
    );

    // Subscribe to face anchors if plugin supports it (some plugin versions include onAddFaceAnchor)
    // arSessionManager?.onAddFaceAnchor = (anchor) {
    //   // optional: handle face anchor added (anchor.identifier etc.)
    // };
    // arSessionManager?.onRemoveFaceAnchor = (anchor) {
    //   // optional: handle removal
    // };
  }

  Future<void> addLocalGLB(String assetPath,
      {List<double>? scale, List<double>? position, List<double>? rotation}) async {
    if (arObjectManager == null) return;
    isLoading.value = true;
    try {
      // Remove previous
      if (faceNode != null) {
        await arObjectManager!.removeNode(faceNode!);
        faceNode = null;
      }

      faceNode = ARNode(
        type: NodeType.localGLTF2,
        uri: assetPath, // e.g. "assets/models/hat.glb"
        scale: Vector3(scale?[0] ?? 0.01, scale?[1] ?? 0.01, scale?[2] ?? 0.01),
        position: Vector3(position?[0] ?? 0.0, position?[1] ?? 0.0, position?[2] ?? 0.0),
        rotation: Vector4(rotation?[0] ?? 0.0, rotation?[1] ?? 0.0, rotation?[2] ?? 0.0, rotation?[3] ?? 0.0),
      );

      await arObjectManager!.addNode(faceNode!);
      // Note: Face tracking attachment depends on AR session configuration and plugin capabilities
      // Some plugins automatically attach nodes to detected faces when face tracking is enabled in the session
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addRemoteGLB(String url,
      {List<double>? scale, List<double>? position, List<double>? rotation}) async {
    isLoading.value = true;
    try {
      final file = await _downloadToTempFile(url);
      if (file == null) throw Exception('Download failed');
      // For many AR plugins localGLTF2 expects either "file://..." or a path - adapt as needed:
      final uri = file.path;
      await addLocalGLB(uri, scale: scale, position: position, rotation: rotation);
    } finally {
      isLoading.value = false;
    }
  }

  Future<File?> _downloadToTempFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/downloaded_model_${DateTime.now().millisecondsSinceEpoch}.glb');
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } catch (_) {
      return null;
    }
  }

  @override
  void onClose() {
    // cleanup
    super.onClose();
  }
}
