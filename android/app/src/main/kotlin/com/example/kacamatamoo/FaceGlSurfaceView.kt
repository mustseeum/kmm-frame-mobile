package com.example.kacamatamoo

import android.content.Context
import android.opengl.GLSurfaceView

class FaceGlSurfaceView(
    context: Context,
    modelPath: String
) : GLSurfaceView(context) {

    private val renderer: GlassesRenderer

    init {
        setEGLContextClientVersion(2)

        renderer = GlassesRenderer(modelPath)
        setRenderer(renderer)

        renderMode = RENDERMODE_CONTINUOUSLY
    }

    fun updateFace(
        leftX: Float,
        leftY: Float,
        rightX: Float,
        rightY: Float
    ) {
        renderer.updateFace(leftX, leftY, rightX, rightY)
    }
}
