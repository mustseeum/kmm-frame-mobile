package com.kacamatamoo.app

import android.content.Context
import android.opengl.Matrix
import android.os.Handler
import android.os.HandlerThread
import android.util.Log
import android.view.Surface
import android.view.SurfaceHolder
import android.view.SurfaceView
import com.google.android.filament.android.UiHelper

/**
 * A SurfaceView that uses Filament to render a loaded GLB model.
 * Handles lifecycle and rendering loop.
 */
class FilamentView(context: Context) : SurfaceView(context), SurfaceHolder.Callback {

    private val renderer = FilamentRenderer()
    private val glThread = HandlerThread("FilamentGLThread").apply { start() }
    private val glHandler = Handler(glThread.looper)
    private val uiHelper = UiHelper(UiHelper.ContextErrorPolicy.DONT_CHECK)
    @Volatile private var running = false
    private var surfaceWidth = 0
    private var surfaceHeight = 0
    private val renderRunnable = object : Runnable {
        override fun run() {
            if (!running) return
            try {
                renderer.render()
            } catch (e: Exception) {
                Log.e("FaceAR", "Render loop error: ${e.localizedMessage}", e)
            }
            glHandler.postDelayed(this, 16L)
        }
    }

    init {
        holder.addCallback(this)
        uiHelper.renderCallback = object : UiHelper.RendererCallback {
            override fun onNativeWindowChanged(surface: Surface) {
                glHandler.post {
                    renderer.setSurfaceAndViewport(surface, surfaceWidth, surfaceHeight)
                }
            }

            override fun onDetachedFromSurface() {
                glHandler.post {
                    renderer.detachSurface()
                }
            }

            override fun onResized(width: Int, height: Int) {
                surfaceWidth = width
                surfaceHeight = height
                glHandler.post {
                    renderer.resizeViewport(width, height)
                }
            }
        }
    }

    override fun surfaceCreated(holder: SurfaceHolder) {
        Log.d("FaceAR", "FilamentView surface created")
        running = true
        uiHelper.attachTo(this)
        glHandler.post {
            renderer.init()
        }
    }

    override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
        Log.d("FaceAR", "FilamentView surface changed: $width x $height")
        surfaceWidth = width
        surfaceHeight = height
        if (running) {
            glHandler.removeCallbacks(renderRunnable)
            glHandler.post(renderRunnable)
        }
    }

    override fun surfaceDestroyed(holder: SurfaceHolder) {
        Log.d("FaceAR", "FilamentView surface destroyed")
        running = false
        glHandler.removeCallbacks(renderRunnable)
        uiHelper.detach()
        glHandler.post {
            renderer.destroyResources()
        }
    }

    /**
     * Load a 3D model (GLB format) for rendering.
     * This is called on the GL thread to ensure thread safety.
     * 
     * @param path Absolute file path to the GLB model file
     */
    fun loadModel(path: String) {
        try {
            glHandler.post {
                renderer.loadGlb(path)
                Log.d("FaceAR", "Model queued for loading: $path")
            }
        } catch (e: Exception) {
            Log.e("FaceAR", "Error queueing model: ${e.localizedMessage}")
        }
    }

    /**
     * Update 3D glasses model with PD-accurate scaling.
     * This is the recommended method for production use - provides accurate sizing.
     * 
     * @param leftX Left eye X position (normalized 0-1)
     * @param leftY Left eye Y position (normalized 0-1)
     * @param rightX Right eye X position (normalized 0-1)
     * @param rightY Right eye Y position (normalized 0-1)
     * @param eulerY Head yaw rotation in degrees
     * @param eulerZ Head roll rotation in degrees
     * @param eulerX Head pitch rotation in degrees
     * @param pdScale Pupillary distance-based scale factor (from PupillaryDistanceCalculator)
     * @param actualPD User's actual PD in millimeters (for analytics/logging)
     */
    fun updateFaceWithPD(
        leftX: Float, leftY: Float,
        rightX: Float, rightY: Float,
        eulerY: Float, eulerZ: Float, eulerX: Float,
        pdScale: Float,
        actualPD: Float
    ) {
        try {
            glHandler.post {
                // Calculate face center point
                val midX = (leftX + rightX) / 2f
                val midY = (leftY + rightY) / 2f

                // Use PD-based scale (already calculated accurately)
                val finalScale = pdScale

                // Get the root entity of the loaded 3D model
                val root = renderer.getRootEntity()

                // Create transformation matrix
                val matrix = FloatArray(16)
                Matrix.setIdentityM(matrix, 0)

                // Apply transforms: Translate -> Rotate -> Scale
                Matrix.translateM(matrix, 0, 
                    (midX - 0.5f) * 2f,
                    (0.5f - midY) * 2f,
                    -0.1f
                )

                // Apply rotations in YXZ order (natural head movement)
                Matrix.rotateM(matrix, 0, eulerY, 0f, 1f, 0f)  // Yaw
                Matrix.rotateM(matrix, 0, eulerX, 1f, 0f, 0f)  // Pitch
                Matrix.rotateM(matrix, 0, eulerZ, 0f, 0f, 1f)  // Roll

                // Apply PD-accurate scale
                Matrix.scaleM(matrix, 0, finalScale, finalScale, finalScale)

                // Apply final transform
                renderer.updateTransform(root, matrix)

                // Log PD info periodically for debugging
                if (System.currentTimeMillis() % 1000 < 20) {  // ~once per second
                    Log.d("FaceAR", "PD: ${actualPD}mm, Scale: $finalScale")
                }
            }
        } catch (e: Exception) {
            Log.e("FaceAR", "Error updating face with PD: ${e.localizedMessage}")
        }
    }

    /**
     * Update 3D glasses model position and rotation based on face tracking data.
     * This method applies full 6DOF (6 degrees of freedom) transformation:
     * - Translation (X, Y, Z position)
     * - Rotation (yaw, pitch, roll)
     * - Scale (based on interpupillary distance)
     * 
     * @param leftX Left eye X position (normalized 0-1)
     * @param leftY Left eye Y position (normalized 0-1)
     * @param rightX Right eye X position (normalized 0-1)
     * @param rightY Right eye Y position (normalized 0-1)
     * @param eulerY Head yaw rotation in degrees (-90 to +90, left/right look)
     * @param eulerZ Head roll rotation in degrees (-45 to +45, head tilt)
     * @param eulerX Head pitch rotation in degrees (-45 to +45, up/down look)
     * @param eyeDistancePixels Distance between eyes in pixels (for scaling)
     */
    fun updateFaceWithRotation(
        leftX: Float, leftY: Float,
        rightX: Float, rightY: Float,
        eulerY: Float, eulerZ: Float, eulerX: Float,
        eyeDistancePixels: Float
    ) {
        try {
            glHandler.post {
                // Calculate face center point (midpoint between eyes)
                val midX = (leftX + rightX) / 2f
                val midY = (leftY + rightY) / 2f

                // Calculate base scale from eye distance
                // Average IPD is ~63mm, typical camera at 30cm gives ~150-200 pixels
                // Adjust multiplier based on your model size and camera resolution
                val baseScale = 0.015f * (eyeDistancePixels / 150f)

                // Get the root entity of the loaded 3D model
                val root = renderer.getRootEntity()

                // Create transformation matrix (4x4 matrix for 3D transforms)
                val matrix = FloatArray(16)
                Matrix.setIdentityM(matrix, 0)

                // Step 1: Translate to face center position
                // Convert from image coordinates (0-1) to OpenGL coordinates (-1 to 1)
                Matrix.translateM(matrix, 0, 
                    (midX - 0.5f) * 2f,      // X: left-right position
                    (0.5f - midY) * 2f,      // Y: up-down position (inverted)
                    -0.1f                     // Z: slight forward offset
                )

                // Step 2: Apply head rotations in proper order (YXZ)
                // Order matters! Yaw -> Pitch -> Roll gives natural head movement
                Matrix.rotateM(matrix, 0, eulerY, 0f, 1f, 0f)  // Yaw (Y-axis)
                Matrix.rotateM(matrix, 0, eulerX, 1f, 0f, 0f)  // Pitch (X-axis)
                Matrix.rotateM(matrix, 0, eulerZ, 0f, 0f, 1f)  // Roll (Z-axis)

                // Step 3: Apply uniform scale
                Matrix.scaleM(matrix, 0, baseScale, baseScale, baseScale)

                // Apply final transform to the 3D model
                renderer.updateTransform(root, matrix)
            }
        } catch (e: Exception) {
            Log.e("FaceAR", "Error updating face with rotation: ${e.localizedMessage}")
        }
    }

    /**
     * Legacy method for backward compatibility.
     * Calls new rotation-aware method with zero rotation.
     * 
     * @deprecated Use updateFaceWithRotation() for full tracking
     */
    @Deprecated("Use updateFaceWithRotation for better tracking")
    fun updateFace(leftX: Float, leftY: Float, rightX: Float, rightY: Float) {
        // Calculate eye distance for scale
        val eyeDist = kotlin.math.abs(rightX - leftX)
        val eyeDistPixels = eyeDist * 200f  // Approximate conversion
        
        // Call new method with no rotation
        updateFaceWithRotation(
            leftX, leftY, rightX, rightY,
            0f, 0f, 0f,  // No rotation
            eyeDistPixels
        )
    }
}
