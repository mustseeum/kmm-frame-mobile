package com.example.kacamatamoo

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "kacamatamoo/face_ar"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "startFaceAr" -> {
                    val assetPath = call.argument<String>("assetPath")
                    startFaceArActivity(assetPath)
                    result.success(null)
                }

                "stopFaceAr" -> {
                    result.success(null)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun startFaceArActivity(assetPath: String?) {
        val intent = Intent(this, FaceArActivity::class.java)
        intent.putExtra("assetPath", assetPath)
        startActivity(intent)
    }
}
