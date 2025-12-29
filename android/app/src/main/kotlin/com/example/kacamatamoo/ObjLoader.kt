package com.example.kacamatamoo

import java.io.BufferedReader
import java.io.File
import java.io.FileReader
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.FloatBuffer

object ObjLoader {

    fun load(filePath: String): FloatBuffer {
        val vertices = mutableListOf<Float>()

        BufferedReader(FileReader(File(filePath))).useLines { lines ->
            lines.forEach { line ->
                val parts = line.trim().split("\\s+".toRegex())
                if (parts.isEmpty()) return@forEach

                if (parts[0] == "v") {
                    vertices.add(parts[1].toFloat())
                    vertices.add(parts[2].toFloat())
                    vertices.add(parts[3].toFloat())
                }
            }
        }

        val buffer = ByteBuffer
            .allocateDirect(vertices.size * 4)
            .order(ByteOrder.nativeOrder())
            .asFloatBuffer()

        vertices.forEach { buffer.put(it) }
        buffer.position(0)

        return buffer
    }
}
