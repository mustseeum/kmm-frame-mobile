package com.kacamatamoo.app

import android.util.Log
import kotlin.math.abs
import kotlin.math.sqrt

/**
 * Utility class for calculating and applying pupillary distance (PD) measurements.
 * 
 * Pupillary Distance (PD) is the distance between the centers of the pupils,
 * measured in millimeters. Average adult PD is 63mm (range: 54-74mm).
 * 
 * This is critical for accurate glasses fitting in optical retail applications.
 */
object PupillaryDistanceCalculator {
    
    // Constants for PD calculation
    private const val AVERAGE_PD_MM = 63f           // Average adult PD in millimeters
    private const val MIN_PD_MM = 54f               // Minimum realistic PD
    private const val MAX_PD_MM = 74f               // Maximum realistic PD
    private const val AVERAGE_FACE_WIDTH_MM = 140f  // Average face width in mm
    
    // Camera calibration parameters (adjust based on device testing)
    private const val ESTIMATED_CAMERA_DISTANCE_MM = 300f  // ~30cm typical selfie distance
    
    /**
     * Calculate real-world pupillary distance from pixel measurements.
     * Uses camera FOV and estimated face distance to convert pixel distance to millimeters.
     * 
     * @param eyeDistancePixels Distance between eyes in pixels from face detection
     * @param imageWidth Width of the camera frame in pixels
     * @param userProvidedPD Optional: User's known PD in mm (from prescription or measurement)
     * @return Estimated PD in millimeters
     */
    fun calculatePD(
        eyeDistancePixels: Float,
        imageWidth: Int,
        userProvidedPD: Float? = null
    ): Float {
        // If user provided their actual PD, use it (most accurate)
        if (userProvidedPD != null && userProvidedPD in MIN_PD_MM..MAX_PD_MM) {
            Log.d("FaceAR", "Using user-provided PD: ${userProvidedPD}mm")
            return userProvidedPD
        }
        
        // Estimate PD based on pixel measurements
        // This assumes a standard camera FOV (~60-70 degrees) and typical distance
        val faceWidthRatio = eyeDistancePixels / imageWidth
        val estimatedPD = faceWidthRatio * AVERAGE_FACE_WIDTH_MM * 0.45f  // Eyes are ~45% of face width
        
        // Clamp to realistic range
        val clampedPD = estimatedPD.coerceIn(MIN_PD_MM, MAX_PD_MM)
        
        Log.d("FaceAR", "Calculated PD: ${clampedPD}mm (from ${eyeDistancePixels}px)")
        return clampedPD
    }
    
    /**
     * Calculate optimal scale factor for 3D glasses model based on PD.
     * This ensures the virtual glasses match the user's actual face size.
     * 
     * @param measuredPD The measured/calculated PD in millimeters
     * @param modelBasePD The PD that the 3D model was designed for (default: 63mm)
     * @param eyeDistancePixels Current pixel distance for additional scaling
     * @return Scale multiplier for the 3D model
     */
    fun calculateScaleForPD(
        measuredPD: Float,
        modelBasePD: Float = AVERAGE_PD_MM,
        eyeDistancePixels: Float
    ): Float {
        // Base scale from PD ratio (smaller PD = smaller glasses)
        val pdScale = measuredPD / modelBasePD
        
        // Additional dynamic scale from current pixel distance (accounts for distance changes)
        // Typical eye distance at 30cm: ~180-220 pixels on most devices
        val pixelScale = (eyeDistancePixels / 200f).coerceIn(0.5f, 2.0f)
        
        // Combine both scales with weighting (favor PD measurement)
        val finalScale = (pdScale * 0.7f + pixelScale * 0.3f)
        
        Log.d("FaceAR", "Scale calculation: PD=${measuredPD}mm, pdScale=${pdScale}, " +
            "pixelScale=${pixelScale}, final=${finalScale}")
        
        return finalScale.coerceIn(0.6f, 1.4f)  // Safety clamp
    }
    
    /**
     * Calculate frame width recommendation based on PD.
     * Optical rule: Frame width should be approximately face width (PD * 2.3).
     * 
     * @param pd Pupillary distance in millimeters
     * @return Recommended frame width in millimeters
     */
    fun recommendedFrameWidth(pd: Float): Float {
        return pd * 2.3f
    }
    
    /**
     * Smooth PD measurements over time to reduce jitter.
     * Uses exponential moving average.
     */
    class PDSmoother(private val smoothingFactor: Float = 0.3f) {
        private var smoothedPD: Float? = null
        
        /**
         * Add a new PD measurement and get smoothed result.
         * 
         * @param newPD New PD measurement in millimeters
         * @return Smoothed PD value
         */
        fun smooth(newPD: Float): Float {
            smoothedPD = if (smoothedPD == null) {
                newPD  // First measurement, no smoothing
            } else {
                // Exponential moving average
                smoothedPD!! * (1f - smoothingFactor) + newPD * smoothingFactor
            }
            return smoothedPD!!
        }
        
        /**
         * Reset the smoother (e.g., when user changes or new session starts).
         */
        fun reset() {
            smoothedPD = null
        }
    }
    
    /**
     * Validate if a PD measurement is realistic for an adult.
     * 
     * @param pd PD value to validate
     * @return true if PD is within realistic human range
     */
    fun isValidPD(pd: Float): Boolean {
        return pd in MIN_PD_MM..MAX_PD_MM
    }
}
