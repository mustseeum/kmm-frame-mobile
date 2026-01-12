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
