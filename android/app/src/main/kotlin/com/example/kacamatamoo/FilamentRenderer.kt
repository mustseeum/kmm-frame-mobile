package com.example.kacamatamoo

import android.util.Log
import com.google.android.filament.*
import com.google.android.filament.gltfio.AssetLoader
import com.google.android.filament.gltfio.FilamentAsset
import com.google.android.filament.gltfio.ResourceLoader
import java.nio.ByteBuffer

/**
 * Manages Filament engine lifecycle, GLB asset loading, and rendering.
 * Thread-safe where needed (asset loading on background, transforms on GL thread).
 */
class FilamentRenderer {

    private var engine: Engine? = null
    private var renderer: Renderer? = null
    private var scene: Scene? = null
    private var view: View? = null
    private var swapChain: SwapChain? = null
    private var cameraEntity: Int = 0

    private var assetLoader: AssetLoader? = null
    private var resourceLoader: ResourceLoader? = null
    private var filamentAsset: FilamentAsset? = null

    fun init() {
        engine = Engine.create()
        renderer = engine?.createRenderer() ?: return
        scene = engine?.createScene() ?: return

        // Create camera
        val em = EntityManager.get()
        cameraEntity = em.create()
        val camera = engine?.createCamera(cameraEntity) ?: return

        // Setup view
        view = engine?.createView() ?: return
        view?.scene = scene
        view?.camera = camera

        assetLoader = engine?.let { AssetLoader(it, EntityManager.get()) }
        resourceLoader = engine?.let { ResourceLoader(it) }

        Log.d("FaceAR", "FilamentRenderer initialized")
    }

    fun loadGlb(path: String) {
        try {
            val bytes = java.io.File(path).readBytes()
            val bb = ByteBuffer.allocateDirect(bytes.size)
            bb.put(bytes)
            bb.position(0)

            filamentAsset = assetLoader?.createAssetFromBinary(bb)
            filamentAsset?.let { asset ->
                resourceLoader?.loadResources(asset)
                asset.releaseSourceData()
                scene?.addEntities(asset.entities)
                Log.d("FaceAR", "GLB loaded: $path (${asset.entities.size} entities)")
            } ?: Log.e("FaceAR", "Failed to load asset from $path")

        } catch (e: Exception) {
            Log.e("FaceAR", "Error loading GLB: ${e.localizedMessage}")
        }
    }

    fun setSurfaceAndViewport(surface: Any?, width: Int, height: Int) {
        try {
            if (surface != null && swapChain == null) {
                swapChain = engine?.createSwapChain(surface)
            }
            view?.setViewport(0, 0, width, height)
        } catch (e: Exception) {
            Log.e("FaceAR", "Error setting surface/viewport: ${e.localizedMessage}")
        }
    }

    fun updateTransform(entity: Int, matrix: FloatArray) {
        try {
            val tm = engine?.transformManager ?: return
            tm.setTransform(entity, matrix)
        } catch (e: Exception) {
            Log.e("FaceAR", "Error updating transform: ${e.localizedMessage}")
        }
    }

    fun getRootEntity(): Int {
        return filamentAsset?.root ?: EntityManager.get().create()
    }

    fun render(): Boolean {
        val r = renderer ?: return false
        val v = view ?: return false
        val sc = swapChain ?: return false

        return try {
            if (r.beginFrame(sc)) {
                r.render(v)
                r.endFrame()
                true
            } else {
                false
            }
        } catch (e: Exception) {
            Log.e("FaceAR", "Render error: ${e.localizedMessage}")
            false
        }
    }

    fun destroyResources() {
        try {
            removeCallbacks()
            swapChain?.let { engine?.destroySwapChain(it) }
            view?.let { engine?.destroyView(it) }
            scene?.let { engine?.destroyScene(it) }
            renderer?.let { engine?.destroyRenderer(it) }
            resourceLoader?.destroy()
            assetLoader?.destroy()
            filamentAsset = null
            Engine.destroy(engine)
            engine = null
        } catch (e: Exception) {
            Log.e("FaceAR", "Error destroying resources: ${e.localizedMessage}")
        }
    }

    private fun removeCallbacks() {
        // override in subclass if needed
    }
}
