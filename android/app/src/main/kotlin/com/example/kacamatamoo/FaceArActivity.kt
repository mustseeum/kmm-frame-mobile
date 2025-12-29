package com.example.kacamatamoo

import android.graphics.PointF
import android.os.Bundle
import android.util.Size
import android.widget.FrameLayout
import androidx.activity.ComponentActivity
import androidx.camera.core.*
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.core.content.ContextCompat
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.face.*
import java.util.concurrent.Executors

class FaceArActivity : ComponentActivity() {

    private lateinit var previewView: PreviewView
    private lateinit var rendererView: FaceGlSurfaceView
    private lateinit var faceDetector: FaceDetector

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val modelPath = intent.getStringExtra("MODEL_PATH")
            ?: error("MODEL_PATH missing")

        previewView = PreviewView(this)
        rendererView = FaceGlSurfaceView(this, modelPath)

        setContentView(
            FrameLayout(this).apply {
                addView(previewView)
                addView(rendererView)
            }
        )

        setupFaceDetector()
        startCamera()
    }

    private fun setupFaceDetector() {
        val options = FaceDetectorOptions.Builder()
            .setPerformanceMode(FaceDetectorOptions.PERFORMANCE_MODE_FAST)
            .setLandmarkMode(FaceDetectorOptions.LANDMARK_MODE_ALL)
            .build()

        faceDetector = FaceDetection.getClient(options)
    }

    private fun startCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)

        cameraProviderFuture.addListener({
            val cameraProvider = cameraProviderFuture.get()

            val preview = Preview.Builder().build().also {
                it.setSurfaceProvider(previewView.surfaceProvider)
            }

            val analysis = ImageAnalysis.Builder()
                .setTargetResolution(Size(640, 480))
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .build()

            analysis.setAnalyzer(
                Executors.newSingleThreadExecutor()
            ) { imageProxy ->
                analyzeImage(imageProxy)
            }

            cameraProvider.unbindAll()
            cameraProvider.bindToLifecycle(
                this,
                CameraSelector.DEFAULT_FRONT_CAMERA,
                preview,
                analysis
            )

        }, ContextCompat.getMainExecutor(this))
    }

    private fun analyzeImage(imageProxy: ImageProxy) {
        val mediaImage = imageProxy.image ?: run {
            imageProxy.close()
            return
        }

        val image = InputImage.fromMediaImage(
            mediaImage,
            imageProxy.imageInfo.rotationDegrees
        )

        faceDetector.process(image)
            .addOnSuccessListener { faces ->
                if (faces.isNotEmpty()) {
                    val face = faces[0]

                    val left = face.getLandmark(FaceLandmark.LEFT_EYE)?.position
                    val right = face.getLandmark(FaceLandmark.RIGHT_EYE)?.position

                    if (left != null && right != null) {
                        rendererView.updateFace(
                            left.x, left.y,
                            right.x, right.y
                        )
                    }
                }
            }
            .addOnCompleteListener {
                imageProxy.close()
            }
    }
}
