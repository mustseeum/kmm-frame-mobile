import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:augen/augen.dart';

class FunctionHelper {
	FunctionHelper._();

	/// Determines if the current screen width is tablet size.
	///
	/// Returns `true` if the max width is greater than or equal to 768.
	static bool isTablet(BoxConstraints constraints) {
		return constraints.maxWidth >= 768;
	}

	/// Calculates the container width based on screen size.
	///
	/// Returns 60% of the screen width for tablets, and 92% for mobile devices.
	static double getContainerWidth(BoxConstraints constraints) {
		final isTabletSize = isTablet(constraints);
		return isTabletSize
				? constraints.maxWidth * 0.6
				: constraints.maxWidth * 0.92;
	}

	/// Requests and handles camera permission.
	///
	/// Returns `true` when permission is granted. If permission is permanently
	/// denied and [openSettingsIfPermanentlyDenied] is `true`, the app settings
	/// screen will be opened.
	static Future<bool> handleCameraPermission({
		bool openSettingsIfPermanentlyDenied = false,
	}) async {
		final status = await Permission.camera.status;

		if (status.isGranted) return true;

		if (status.isDenied || status.isRestricted || status.isLimited) {
			final result = await Permission.camera.request();
			return result.isGranted;
		}

		if (status.isPermanentlyDenied) {
			if (openSettingsIfPermanentlyDenied) {
				await openAppSettings();
			}
			return false;
		}

		// Fallback: request permission
		final result = await Permission.camera.request();
		return result.isGranted;
	}
}

// ---------- DeepAR helpers (global) ----------

DeepArController? _deepArController;

Future<DeepArController> initDeepArController({
	String? androidLicenseKey,
	String? iosLicenseKey,
	Resolution resolution = Resolution.high,
}) async {
	if (_deepArController != null) return _deepArController!;

	_deepArController = DeepArController();

	_deepArController!.initialize(
		androidLicenseKey: androidLicenseKey ?? dotenv.env['KEY_AR_ANDROID'] ?? '',
		resolution: resolution,
		iosLicenseKey: iosLicenseKey ?? dotenv.env['KEY_AR_IOS'] ?? '',
	);

	return _deepArController!;
}

Future<void> ensureDeepArInitialized({
	String? androidLicenseKey,
	String? iosLicenseKey,
	Resolution resolution = Resolution.high,
}) async {
	await initDeepArController(
		androidLicenseKey: androidLicenseKey,
		iosLicenseKey: iosLicenseKey,
		resolution: resolution,
	);
}

DeepArController getDeepArController() {
	if (_deepArController == null) {
		throw StateError('DeepArController is not initialized. Call ensureDeepArInitialized() first.');
	}
	return _deepArController!;
}

// ---------- Augen AR helpers (global) ----------

// AugenController? _augenController;

// /// Callback when AugenController is created from the view
// void onAugenViewCreated(AugenController controller) {
// 	_augenController = controller;
// }

// /// Initialize Augen AR session with configuration
// Future<bool> initializeAugenAR({
// 	bool planeDetection = true,
// 	bool lightEstimation = true,
// }) async {
// 	if (_augenController == null) {
// 		throw StateError('AugenController is not set. Call onAugenViewCreated() first.');
// 	}

// 	// Check AR support
// 	final isSupported = await _augenController!.isARSupported();
// 	if (!isSupported) {
// 		debugPrint('AR is not supported on this device');
// 		return false;
// 	}

// 	// Initialize AR session
// 	await _augenController!.initialize(
// 		ARSessionConfig(
// 			planeDetection: planeDetection,
// 			lightEstimation: lightEstimation,
// 		),
// 	);

// 	return true;
// }

// /// Get the current AugenController instance
// AugenController? getAugenController() {
// 	return _augenController;
// }

// /// Listen to detected planes stream
// Stream<List<ARPlane>>? getAugenPlanesStream() {
// 	return _augenController?.planesStream;
// }

// /// Dispose Augen AR controller
// void disposeAugenController() {
// 	_augenController?.dispose();
// 	_augenController = null;
// }

// /// Set up face tracking with glasses overlay
// /// TODO: Enable when augen package supports these methods
// Future<void> setupAugenFaceTracking({
// 	String glassesModelPath = 'assets/models/test_image_asset.glb',
// 	Vector3? glassesPosition,
// 	Vector3? glassesScale,
// 	bool detectLandmarks = true,
// 	bool detectExpressions = true,
// 	double minFaceSize = 0.1,
// 	double maxFaceSize = 1.0,
// }) async {
// 	if (_augenController == null) {
// 		throw StateError('AugenController is not set. Call onAugenViewCreated() first.');
// 	}

// 	debugPrint('Face tracking setup - waiting for augen package implementation');
	
// 	// COMMENTED OUT: These methods are not yet implemented in augen package
// 	/*
// 	// Enable face tracking
// 	await _augenController!.setFaceTrackingEnabled(true);

// 	// Configure face tracking
// 	await _augenController!.setFaceTrackingConfig(
// 		detectLandmarks: detectLandmarks,
// 		detectExpressions: detectExpressions,
// 		minFaceSize: minFaceSize,
// 		maxFaceSize: maxFaceSize,
// 	);

// 	// Listen for tracked faces and apply glasses
// 	_augenController!.facesStream.listen((faces) {
// 		for (final face in faces) {
// 			if (face.isTracked && face.isReliable) {
// 				// Add 3D glasses model to the tracked face
// 				final glasses = ARNode.fromModel(
// 					id: 'glasses_${face.id}',
// 					modelPath: glassesModelPath,
// 					position: glassesPosition ?? const Vector3(0, 0, 0.1), // 10cm in front of face
// 					scale: glassesScale ?? const Vector3(0.1, 0.1, 0.1),
// 				);

// 				_augenController!.addNodeToTrackedFace(
// 					nodeId: 'glasses_${face.id}',
// 					faceId: face.id,
// 					node: glasses,
// 				);

// 				// Get and log face landmarks
// 				_augenController!.getFaceLandmarks(face.id).then((landmarks) {
// 					for (final landmark in landmarks) {
// 						debugPrint('Landmark ${landmark.name}: ${landmark.position}');
// 					}
// 				});
// 			}
// 		}
// 	});
// 	*/

// 	debugPrint('Face tracking setup completed (placeholder)');
// }

// /// Get faces stream
// Stream<List<ARFace>>? getAugenFacesStream() {
// 	return _augenController?.facesStream;
// }