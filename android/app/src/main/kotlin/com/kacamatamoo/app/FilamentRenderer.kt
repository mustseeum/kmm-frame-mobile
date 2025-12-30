package com.kacamatamoo.app

import android.util.Log
import com.google.android.filament.*
import com.google.android.filament.gltfio.AssetLoader
import com.google.android.filament.gltfio.FilamentAsset
import com.google.android.filament.gltfio.ResourceLoader
import com.google.android.filament.gltfio.UbershaderProvider
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
        try {
            engine = Engine.create()
            if (engine == null) {
                Log.e("FaceAR", "Engine.create() returned null")
                return
            }
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

            engine?.let { eng ->
                val matProvider = UbershaderProvider(eng)
                assetLoader = AssetLoader(eng, matProvider, EntityManager.get())
                resourceLoader = ResourceLoader(eng)
            }

            Log.d("FaceAR", "FilamentRenderer initialized successfully")
        } catch (e: Exception) {
            Log.e("FaceAR", "FilamentRenderer.init() failed: ${e.localizedMessage}", e)
        }
    }

    fun loadGlb(path: String) {
        try {
            val bytes = java.io.File(path).readBytes()
            val bb = ByteBuffer.allocateDirect(bytes.size)
            bb.put(bytes)
            bb.flip()

                assetLoader?.let { loader ->
                    filamentAsset = loader.createAsset(bb)
                    filamentAsset?.let { asset ->
                        resourceLoader?.loadResources(asset)
                        asset.releaseSourceData()
                        scene?.addEntities(asset.entities)
                        Log.d("FaceAR", "GLB loaded: $path (${asset.entities.size} entities)")
                    } ?: Log.e("FaceAR", "Failed to load asset from $path")
                }

        } catch (e: Exception) {
            Log.e("FaceAR", "Error loading GLB: ${e.localizedMessage}")
        }
    }

    fun setSurfaceAndViewport(surface: Any?, width: Int, height: Int) {
        try {
            if (surface != null) {
                // Recreate swap chain if surface changes
                swapChain?.let { engine?.destroySwapChain(it) }
                swapChain = engine?.createSwapChain(surface)
            }
            val viewport = Viewport(0, 0, width, height)
            view?.viewport = viewport
        } catch (e: Exception) {
            Log.e("FaceAR", "Error setting surface/viewport: ${e.localizedMessage}")
        }
    }

    fun resizeViewport(width: Int, height: Int) {
        try {
            val viewport = Viewport(0, 0, width, height)
            view?.viewport = viewport
        } catch (e: Exception) {
            Log.e("FaceAR", "Error resizing viewport: ${e.localizedMessage}")
        }
    }

    /**
     * Detach the rendering surface.
     * Called when the surface is destroyed (e.g., activity going to background).
     */
    fun detachSurface() {
        try {
            swapChain?.let { engine?.destroySwapChain(it) }
            swapChain = null
        } catch (e: Exception) {
            Log.e("FaceAR", "Error detaching surface: ${e.localizedMessage}")
        }
    }

    /**
     * Update the transformation matrix of a 3D entity.
     * Applies position, rotation, and scale to the model in 3D space.
     * 
     * @param entity The Filament entity ID to transform
     * @param matrix 4x4 transformation matrix (16 floats in column-major order)
     */
    fun updateTransform(entity: Int, matrix: FloatArray) {
        try {
            val tm = engine?.transformManager ?: return
            val instance = tm.getInstance(entity)
            
            if (instance != 0) {
                tm.setTransform(instance, matrix)
            }
        } catch (e: Exception) {
            Log.e("FaceAR", "Error updating transform: ${e.localizedMessage}")
        }
    }

    /**
     * Update transforms for all entities in the loaded model.
     * Useful when applying global transforms to the entire glasses frame.
     * 
     * @param matrix 4x4 transformation matrix to apply to all entities
     */
    fun updateAllEntityTransforms(matrix: FloatArray) {
        try {
            filamentAsset?.entities?.forEach { entity ->
                updateTransform(entity, matrix)
            }
        } catch (e: Exception) {
            Log.e("FaceAR", "Error updating all entity transforms: ${e.localizedMessage}")
        }
    }

    /**
     * Get the root entity of the loaded 3D model.
     * The root entity is the parent of all model components.
     * 
     * @return Root entity ID, or a new entity if no model is loaded
     */
    fun getRootEntity(): Int {
        return filamentAsset?.root ?: EntityManager.get().create()
    }

    /**
     * Main render loop - draws one frame.
     * Called repeatedly (typically at 60fps) to update the display.
     * 
     * @return true if frame was rendered successfully, false otherwise
     */
    fun render(): Boolean {
        val r = renderer ?: return false
        val v = view ?: return false
        val sc = swapChain ?: return false

        return try {
            // Begin frame and render if ready
            if (r.beginFrame(sc, 0)) {
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
            filamentAsset?.let { assetLoader?.destroyAsset(it) }
            resourceLoader = null
            assetLoader = null
            filamentAsset = null
            if (cameraEntity != 0) {
                engine?.destroyCameraComponent(cameraEntity)
                EntityManager.get().destroy(cameraEntity)
                cameraEntity = 0
            }
            engine = null
        } catch (e: Exception) {
            Log.e("FaceAR", "Error destroying resources: ${e.localizedMessage}")
        }
    }

    private fun removeCallbacks() {
        // override in subclass if needed
    }
}
