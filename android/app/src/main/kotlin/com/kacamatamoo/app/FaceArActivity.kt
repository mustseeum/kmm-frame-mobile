package com.kacamatamoo.app

import android.graphics.PointF
import android.os.Bundle
import android.os.Handler
import android.util.Size
import android.util.Log
import android.widget.FrameLayout
import androidx.activity.ComponentActivity
import androidx.camera.core.*
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.core.content.ContextCompat
import android.widget.Toast
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.face.*
import com.google.ar.core.ArCoreApk
import com.google.ar.core.AugmentedFace
import com.google.ar.core.CameraConfig
import com.google.ar.core.CameraConfigFilter
import com.google.ar.core.Config
import com.google.ar.core.Session
import com.google.ar.core.TrackingState
import com.google.android.filament.utils.Utils
import java.util.concurrent.Executors

class FaceArActivity : ComponentActivity() {

    private lateinit var previewView: PreviewView
    private lateinit var rendererView: FilamentView
    private lateinit var faceDetector: FaceDetector
    private var arSession: Session? = null
    private var arSupported: Boolean = false
    private var useArCore: Boolean = false  // Flag to track which tracking method is active
    
    // Pupillary distance tracking
    private var userProvidedPD: Float? = null  // User's actual PD from prescription/measurement
    private val pdSmoother = PupillaryDistanceCalculator.PDSmoother()
    private var imageWidth: Int = 0  // Camera frame width for PD calculation

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val modelPath = intent.getStringExtra("MODEL_PATH")
            ?: error("MODEL_PATH missing")
        
        // Get optional user-provided PD from Flutter (in millimeters)
        userProvidedPD = intent.getFloatExtra("USER_PD", -1f).let { 
            if (it > 0) it else null 
        }

        previewView = PreviewView(this)
        rendererView = FilamentView(this)

        // Load Filament native libs (required for Engine.create())
        Utils.init()

        // load model asynchronously
        Thread {
            rendererView.loadModel(modelPath)
        }.start()

        setContentView(
            FrameLayout(this).apply {
                addView(previewView)
                addView(rendererView)
            }
        )

        // Check ARCore Augmented Faces support (non-blocking, non-fatal). Use CameraX+MLKit as fallback.
        try {
            checkArCoreSupport()
        } catch (e: Exception) {
            Log.e("FaceAR", "ARCore check failed (continuing with ML Kit fallback): ${e.localizedMessage}")
        }

        setupFaceDetector()
        startCamera()
        
        // If ARCore is enabled, start ARCore update loop
        if (useArCore) {
            startArCoreLoop()
        }
    }

    /**
     * Check if ARCore Augmented Faces is supported on this device.
     * Augmented Faces provides:
     * - 468-point 3D face mesh (vs ML Kit's 6 landmarks)
     * - Better head pose tracking
     * - Automatic depth/occlusion
     * - More stable tracking
     * 
     * Falls back to ML Kit if ARCore is unavailable or fails.
     */
    private fun checkArCoreSupport() {
        try {
            // Check ARCore availability (may require time to determine)
            val availability = ArCoreApk.getInstance().checkAvailability(this)
            
            // If still checking, retry after delay
            if (availability.isTransient) {
                previewView.postDelayed({ checkArCoreSupport() }, 200)
                return
            }
            
            // ARCore is available, attempt to create session
            if (availability.isSupported) {
                try {
                    arSession = Session(this)

                    // Configure for front-facing camera (required for face tracking)
                    val filter = CameraConfigFilter(arSession)
                    filter.facingDirection = CameraConfig.FacingDirection.FRONT
                    val frontConfig = arSession?.getSupportedCameraConfigs(filter)?.firstOrNull()
                    
                    if (frontConfig != null) {
                        arSession?.cameraConfig = frontConfig

                        // Enable Augmented Faces with 3D mesh
                        val config = Config(arSession)
                        try {
                            config.augmentedFaceMode = Config.AugmentedFaceMode.MESH3D
                            arSession?.configure(config)
                            
                            // Success! Use ARCore for premium tracking
                            arSupported = true
                            useArCore = true
                            
                            Toast.makeText(
                                this, 
                                "✓ ARCore Augmented Faces enabled (Premium Mode): ${modelPath}", 
                                Toast.LENGTH_SHORT
                            ).show()
                            
                            Log.i("FaceAR", "ARCore Augmented Faces successfully enabled")
                        } catch (e: Exception) {
                            // Augmented Faces not supported, fall back to ML Kit
                            Log.w("FaceAR", "Augmented Faces mode not available: ${e.localizedMessage}")
                            arSupported = false
                            useArCore = false
                        }
                    } else {
                        Log.w("FaceAR", "No front-facing camera config found")
                        arSupported = false
                        useArCore = false
                    }
                } catch (e: Exception) {
                    Log.w("FaceAR", "ARCore session creation failed: ${e.localizedMessage}")
                    arSupported = false
                    useArCore = false
                }
            } else {
                // ARCore not supported on this device
                Log.i("FaceAR", "ARCore not supported on this device, using ML Kit fallback")
                arSupported = false
                useArCore = false
            }
        } catch (e: Exception) {
            Log.e("FaceAR", "ARCore check failed: ${e.localizedMessage}")
            arSupported = false
            useArCore = false
        }
        
        // Always show tracking method being used
        if (!useArCore) {
            Toast.makeText(
                this, 
                "Using ML Kit Face Tracking (Standard Mode)", 
                Toast.LENGTH_SHORT
            ).show()
        }
    }

    /**
     * Initialize ML Kit Face Detector with all tracking features enabled.
     * - LANDMARK_MODE_ALL: Enables eye, nose, mouth landmark detection for positioning.
     * - CLASSIFICATION_MODE_ALL: Enables smile/eye-open detection (optional for UX).
     * - CONTOUR_MODE_ALL: Enables face outline tracking for better rotation estimation.
     */
    private fun setupFaceDetector() {
        val options = FaceDetectorOptions.Builder()
            .setPerformanceMode(FaceDetectorOptions.PERFORMANCE_MODE_FAST)
            .setLandmarkMode(FaceDetectorOptions.LANDMARK_MODE_ALL)
            .setClassificationMode(FaceDetectorOptions.CLASSIFICATION_MODE_ALL)
            .setContourMode(FaceDetectorOptions.CONTOUR_MODE_ALL)
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
                // Store image dimensions for PD calculation
                if (imageWidth == 0) {
                    imageWidth = imageProxy.width
                    Log.d("FaceAR", "Camera resolution: ${imageProxy.width}x${imageProxy.height}")
                }
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

    /**
     * Analyze each camera frame for face detection and tracking.
     * Processes the image through ML Kit Face Detection API and updates 3D model position/rotation.
     * 
     * @param imageProxy CameraX image frame containing face data
     */
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
                    // Use the first detected face (primary user)
                    val face = faces[0]

                    // Get eye landmarks for positioning
                    val left = face.getLandmark(FaceLandmark.LEFT_EYE)?.position
                    val right = face.getLandmark(FaceLandmark.RIGHT_EYE)?.position

                    // Get head rotation angles (Euler angles in degrees)
                    // eulerY: Horizontal rotation (yaw) - looking left (-) or right (+)
                    // eulerZ: Tilt rotation (roll) - head tilted left (-) or right (+)  
                    // eulerX: Vertical rotation (pitch) - looking up (+) or down (-)
                    val eulerY = face.headEulerAngleY  // Range: -90° to +90°
                    val eulerZ = face.headEulerAngleZ  // Range: -45° to +45°
                    val eulerX = face.headEulerAngleX  // Range: -45° to +45°

                    if (left != null && right != null) {
                        // Calculate interpupillary distance (IPD) in pixels for accurate scaling
                        val eyeDistancePixels = kotlin.math.sqrt(
                            (right.x - left.x) * (right.x - left.x) +
                            (right.y - left.y) * (right.y - left.y)
                        )

                        // Calculate real-world PD in millimeters
                        val measuredPD = PupillaryDistanceCalculator.calculatePD(
                            eyeDistancePixels,
                            imageWidth,
                            userProvidedPD
                        )
                        
                        // Smooth PD over time to reduce jitter
                        val smoothedPD = pdSmoother.smooth(measuredPD)
                        
                        // Calculate optimal scale based on PD
                        val pdBasedScale = PupillaryDistanceCalculator.calculateScaleForPD(
                            smoothedPD,
                            modelBasePD = 63f,  // Assumes model designed for average 63mm PD
                            eyeDistancePixels
                        )

                        // Update 3D model with position, rotation, and PD-accurate scale
                        rendererView.updateFaceWithPD(
                            left.x, left.y,
                            right.x, right.y,
                            eulerY, eulerZ, eulerX,
                            pdBasedScale,
                            smoothedPD
                        )
                    }
                }
            }
            .addOnCompleteListener {
                imageProxy.close()
            }
    }

    /**
     * Start ARCore Augmented Faces update loop.
     * This provides premium face tracking with 468-point mesh and better pose estimation.
     * Runs in parallel with camera feed for optimal performance.
     */
    private fun startArCoreLoop() {
        val arHandler = Handler(android.os.Looper.getMainLooper())
        val arRunnable = object : Runnable {
            override fun run() {
                if (!useArCore || arSession == null) return
                
                try {
                    // Update ARCore session
                    val frame = arSession?.update()
                    val faces = frame?.getUpdatedTrackables(
                        AugmentedFace::class.java
                    )
                    
                    // Process the first detected face
                    faces?.firstOrNull()?.let { augmentedFace ->
                        if (augmentedFace.trackingState == 
                            TrackingState.TRACKING) {
                            
                            // Get face center pose (position + rotation)
                            val centerPose = augmentedFace.centerPose
                            
                            // Extract position
                            val translation = centerPose.translation
                            val posX = translation[0]
                            val posY = translation[1]
                            val posZ = translation[2]
                            
                            // Extract rotation (quaternion to Euler angles)
                            val rotation = centerPose.rotationQuaternion
                            val eulerAngles = quaternionToEuler(
                                rotation[0], rotation[1], rotation[2], rotation[3]
                            )
                            
                            // Get face regions for scale estimation
                            val noseTip = augmentedFace.getRegionPose(
                                AugmentedFace.RegionType.NOSE_TIP
                            )
                            val leftEye = augmentedFace.getRegionPose(
                                AugmentedFace.RegionType.FOREHEAD_LEFT
                            )
                            val rightEye = augmentedFace.getRegionPose(
                                AugmentedFace.RegionType.FOREHEAD_RIGHT
                            )
                            
                            // Calculate eye distance for scale (3D space)
                            val leftPos = leftEye.translation
                            val rightPos = rightEye.translation
                            val eyeDistance = kotlin.math.sqrt(
                                (rightPos[0] - leftPos[0]) * (rightPos[0] - leftPos[0]) +
                                (rightPos[1] - leftPos[1]) * (rightPos[1] - leftPos[1]) +
                                (rightPos[2] - leftPos[2]) * (rightPos[2] - leftPos[2])
                            )
                            
                            // Convert to screen space for rendering
                            // (This is a simplified conversion - adjust based on camera projection)
                            val screenLeftX = 0.5f + posX * 2f
                            val screenLeftY = 0.5f - posY * 2f
                            val screenRightX = screenLeftX + 0.1f  // Approximate
                            val screenRightY = screenLeftY
                            
                            // Update with ARCore data (more accurate than ML Kit)
                            rendererView.updateFaceWithRotation(
                                screenLeftX, screenLeftY,
                                screenRightX, screenRightY,
                                eulerAngles[1],  // Yaw
                                eulerAngles[2],  // Roll
                                eulerAngles[0],  // Pitch
                                eyeDistance * 1000f  // Convert to pixels equivalent
                            )
                            
                            Log.d("FaceAR", "ARCore tracking: yaw=${eulerAngles[1]}, " +
                                "pitch=${eulerAngles[0]}, roll=${eulerAngles[2]}")
                        }
                    }
                } catch (e: Exception) {
                    Log.w("FaceAR", "ARCore update error: ${e.localizedMessage}")
                }
                
                // Continue loop at 60fps
                arHandler.postDelayed(this, 16L)
            }
        }
        arHandler.post(arRunnable)
    }

    /**
     * Convert quaternion rotation to Euler angles (pitch, yaw, roll).
     * ARCore provides rotation as quaternion, but we need Euler angles for 3D transform.
     * 
     * @return FloatArray of [pitch, yaw, roll] in degrees
     */
    private fun quaternionToEuler(x: Float, y: Float, z: Float, w: Float): FloatArray {
        // Convert quaternion to Euler angles (in radians)
        val pitch = kotlin.math.atan2(
            2f * (w * x + y * z),
            1f - 2f * (x * x + y * y)
        )
        val yaw = kotlin.math.asin(
            kotlin.math.max(-1f, kotlin.math.min(1f, 2f * (w * y - z * x)))
        )
        val roll = kotlin.math.atan2(
            2f * (w * z + x * y),
            1f - 2f * (y * y + z * z)
        )
        
        // Convert to degrees
        return floatArrayOf(
            Math.toDegrees(pitch.toDouble()).toFloat(),
            Math.toDegrees(yaw.toDouble()).toFloat(),
            Math.toDegrees(roll.toDouble()).toFloat()
        )
    }

    override fun onDestroy() {
        super.onDestroy()
        // Clean up ARCore resources
        arSession?.close()
        arSession = null
    }
}
