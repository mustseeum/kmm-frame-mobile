package com.example.kacamatamoo

import android.opengl.GLES20
import android.opengl.GLSurfaceView
import android.opengl.Matrix
import java.nio.FloatBuffer
import javax.microedition.khronos.egl.EGLConfig
import javax.microedition.khronos.opengles.GL10

class GlassesRenderer(
    modelPath: String
) : GLSurfaceView.Renderer {

    private val vertexBuffer: FloatBuffer = ObjLoader.load(modelPath)

    private var program = 0
    private val mvpMatrix = FloatArray(16)
    private val viewMatrix = FloatArray(16)
    private val projMatrix = FloatArray(16)
    private val modelMatrix = FloatArray(16)
    private val tempMatrix = FloatArray(16)

    private var lx = 0f
    private var ly = 0f
    private var rx = 0f
    private var ry = 0f

    fun updateFace(
        leftX: Float,
        leftY: Float,
        rightX: Float,
        rightY: Float
    ) {
        lx = leftX
        ly = leftY
        rx = rightX
        ry = rightY
    }

    override fun onSurfaceCreated(gl: GL10?, config: EGLConfig?) {
        GLES20.glClearColor(0f, 0f, 0f, 0f)

        val vertexShader = """
            uniform mat4 uMVP;
            attribute vec4 vPosition;
            void main() {
                gl_Position = uMVP * vPosition;
            }
        """

        val fragmentShader = """
            precision mediump float;
            void main() {
                gl_FragColor = vec4(0.1, 0.1, 0.1, 1.0);
            }
        """

        program = createProgram(vertexShader, fragmentShader)
    }

    override fun onSurfaceChanged(gl: GL10?, width: Int, height: Int) {
        GLES20.glViewport(0, 0, width, height)
        // Setup a simple perspective and place model at center so it's visible by default
        val ratio = width.toFloat() / height.toFloat()
        Matrix.frustumM(projMatrix, 0, -ratio, ratio, -1f, 1f, 1f, 10f)
        Matrix.setLookAtM(viewMatrix, 0, 0f, 0f, 3f, 0f, 0f, 0f, 0f, 1f, 0f)

        Matrix.setIdentityM(modelMatrix, 0)
        // default scale - tweak if model too large/small
        Matrix.scaleM(modelMatrix, 0, 0.02f, 0.02f, 0.02f)

        Matrix.multiplyMM(tempMatrix, 0, viewMatrix, 0, modelMatrix, 0)
        Matrix.multiplyMM(mvpMatrix, 0, projMatrix, 0, tempMatrix, 0)
    }

    override fun onDrawFrame(gl: GL10?) {
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT)

        GLES20.glUseProgram(program)

        val posHandle = GLES20.glGetAttribLocation(program, "vPosition")
        val mvpHandle = GLES20.glGetUniformLocation(program, "uMVP")

        GLES20.glEnableVertexAttribArray(posHandle)
        GLES20.glVertexAttribPointer(
            posHandle,
            3,
            GLES20.GL_FLOAT,
            false,
            0,
            vertexBuffer
        )

        GLES20.glUniformMatrix4fv(mvpHandle, 1, false, mvpMatrix, 0)
        GLES20.glDrawArrays(
            GLES20.GL_TRIANGLES,
            0,
            vertexBuffer.limit() / 3
        )

        GLES20.glDisableVertexAttribArray(posHandle)
    }

    private fun createProgram(vs: String, fs: String): Int {
        val v = loadShader(GLES20.GL_VERTEX_SHADER, vs)
        val f = loadShader(GLES20.GL_FRAGMENT_SHADER, fs)

        return GLES20.glCreateProgram().also {
            GLES20.glAttachShader(it, v)
            GLES20.glAttachShader(it, f)
            GLES20.glLinkProgram(it)
        }
    }

    private fun loadShader(type: Int, code: String): Int =
        GLES20.glCreateShader(type).also {
            GLES20.glShaderSource(it, code)
            GLES20.glCompileShader(it)
        }
}
