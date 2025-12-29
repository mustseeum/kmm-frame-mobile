package com.example.kacamatamoo

import android.content.Context
import android.opengl.Matrix
import android.util.Log
import android.view.SurfaceHolder
import android.view.SurfaceView

/**
 * A SurfaceView that uses Filament to render a loaded GLB model.
 * Handles lifecycle and rendering loop.
 */
class FilamentView(context: Context) : SurfaceView(context), SurfaceHolder.Callback {

    private val renderer = FilamentRenderer()
    private var renderThread: Thread? = null
    private var running = false

    init {
        holder.addCallback(this)
    }

    override fun surfaceCreated(holder: SurfaceHolder) {
        Log.d("FaceAR", "FilamentView surface created")
        renderer.init()
        running = true
        startRenderThread()
    }

    override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
        Log.d("FaceAR", "FilamentView surface changed: $width x $height")
        renderer.setSurfaceAndViewport(holder.surface, width, height)
    }

    override fun surfaceDestroyed(holder: SurfaceHolder) {
        Log.d("FaceAR", "FilamentView surface destroyed")
        running = false
        renderThread?.join(1000)
        renderer.destroyResources()
    }

    fun loadModel(path: String) {
        try {
            renderer.loadGlb(path)
            Log.d("FaceAR", "Model queued for loading: $path")
        } catch (e: Exception) {
            Log.e("FaceAR", "Error queueing model: ${e.localizedMessage}")
        }
    }

    fun updateFace(leftX: Float, leftY: Float, rightX: Float, rightY: Float) {
        // Map face landmarks to model transform
        val midX = (leftX + rightX) / 2f
        val midY = (leftY + rightY) / 2f
        val eyeDist = kotlin.math.abs(rightX - leftX)
        val scale = 0.02f * (eyeDist / 100f + 1f)

        try {
            val root = renderer.getRootEntity()
            val matrix = FloatArray(16)
            Matrix.setIdentityM(matrix, 0)
            Matrix.translateM(matrix, 0, (midX - 0.5f) * 2f, (0.5f - midY) * 2f, 0f)
            Matrix.scaleM(matrix, 0, scale, scale, scale)
            renderer.updateTransform(root, matrix)
        } catch (e: Exception) {
            Log.e("FaceAR", "Error updating face: ${e.localizedMessage}")
        }
    }

    private fun startRenderThread() {
        renderThread = Thread {
            while (running) {
                try {
                    renderer.render()
                    Thread.sleep(16) // ~60 FPS
                } catch (e: Exception) {
                    Log.e("FaceAR", "Render thread error: ${e.localizedMessage}")
                    Thread.sleep(16)
                }
            }
        }
        renderThread?.start()
    }
}
