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

    fun updateFace(leftX: Float, leftY: Float, rightX: Float, rightY: Float) {
        // Map face landmarks to model transform
        val midX = (leftX + rightX) / 2f
        val midY = (leftY + rightY) / 2f
        val eyeDist = kotlin.math.abs(rightX - leftX)
        val scale = 0.02f * (eyeDist / 100f + 1f)

        try {
            glHandler.post {
                val root = renderer.getRootEntity()
                val matrix = FloatArray(16)
                Matrix.setIdentityM(matrix, 0)
                Matrix.translateM(matrix, 0, (midX - 0.5f) * 2f, (0.5f - midY) * 2f, 0f)
                Matrix.scaleM(matrix, 0, scale, scale, scale)
                renderer.updateTransform(root, matrix)
            }
        } catch (e: Exception) {
            Log.e("FaceAR", "Error updating face: ${e.localizedMessage}")
        }
    }
}
