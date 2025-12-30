package com.kacamatamoo.app

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import android.util.Log

class MainActivity : FlutterActivity() {

    private companion object {
        const val CHANNEL = "kacamatamoo/face_ar"
        const val EXTRA_MODEL_PATH = "MODEL_PATH"
        const val EXTRA_USER_PD = "USER_PD"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "startFaceAr" -> {
                    val assetPath = call.argument<String>("assetPath")
                    val userPD = call.argument<Double>("userPD")  // Optional PD parameter

                    if (assetPath.isNullOrBlank()) {
                        result.error(
                            "INVALID_ARGUMENT",
                            "assetPath is null or empty",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    try {
                        // If caller passed an absolute/local path, use it directly
                        val modelFile = when {
                            assetPath.startsWith("/") || assetPath.startsWith("file://") -> {
                                val p = assetPath.removePrefix("file://")
                                val f = java.io.File(p)
                                if (!f.exists()) throw IllegalArgumentException("File not found: $p")
                                f
                            }
                            assetPath.startsWith("http://") || assetPath.startsWith("https://") -> {
                                // Download remote URL into cache
                                val url = java.net.URL(assetPath)
                                val fileName = assetPath.substringAfterLast('/')
                                val outFile = java.io.File(cacheDir, fileName)
                                if (!outFile.exists()) {
                                    try {
                                        url.openStream().use { input ->
                                            java.io.FileOutputStream(outFile).use { out ->
                                                input.copyTo(out)
                                            }
                                        }
                                        Log.d("FaceAR", "Downloaded remote model to: ${outFile.absolutePath}")
                                    } catch (e: Exception) {
                                        Log.e("FaceAR", "Failed downloading [$assetPath]: ${e.localizedMessage}")
                                        throw e
                                    }
                                }
                                outFile
                            }
                            else -> copyAssetToCache(assetPath)
                        }
                        startFaceArActivity(modelFile.absolutePath, userPD)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error(
                            "ASSET_COPY_FAILED",
                            e.localizedMessage,
                            null
                        )
                    }
                }

                "stopFaceAr" -> {
                    // Optional: finish FaceArActivity via broadcast later
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun copyAssetToCache(assetPath: String): File {
        Log.d("FaceAR", "copyAssetToCache called with: $assetPath")
        val fileName = assetPath.substringAfterLast("/")
        val outFile = File(cacheDir, fileName)

        // Avoid re-copying every time
        if (outFile.exists()) {
            Log.d("FaceAR", "Asset already cached: ${outFile.absolutePath}")
            return outFile
        }

        // Resolve Flutter asset path inside APK's asset folder
        // Flutter packages assets under "flutter_assets/" in the APK.
        val assetKey = "flutter_assets/$assetPath"
        Log.d("FaceAR", "Loading asset from APK: $assetKey")

        try {
            assets.open(assetKey).use { input ->
                FileOutputStream(outFile).use { output ->
                    input.copyTo(output)
                }
            }
            Log.d("FaceAR", "Successfully copied asset to: ${outFile.absolutePath}")
        } catch (e: Exception) {
            Log.e("FaceAR", "Failed copying asset [$assetKey]: ${e.localizedMessage}", e)
            throw e
        }
        return outFile
    }

    /**
     * Launch FaceArActivity with model path and optional user PD.
     * 
     * @param modelPath Absolute file path to the GLB model
     * @param userPD Optional user's pupillary distance in millimeters (54-74mm)
     */
    private fun startFaceArActivity(modelPath: String, userPD: Double? = null) {
        val intent = Intent(this, FaceArActivity::class.java).apply {
            putExtra(EXTRA_MODEL_PATH, modelPath)
            userPD?.let { 
                putExtra(EXTRA_USER_PD, it.toFloat())
                Log.d("FaceAR", "Starting Face AR with user PD: ${it}mm")
            }
        }
        startActivity(intent)
    }
}
