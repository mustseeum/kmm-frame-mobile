plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.kacamatamoo.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.kacamatamoo.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // minSdk = flutter.minSdkVersion
        // targetSdk = flutter.targetSdkVersion
        minSdk = 25
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

     androidResources {
        // Read unityStreamingAssets from gradle.properties
        val unityStreamingAssetsList = (project.findProperty("unityStreamingAssets") as? String)
                ?.split(",")
                ?.map { it.trim() }
                ?: emptyList()

        noCompress += listOf(
        ".unity3d", ".ress", ".resource", ".obb", ".bundle", ".unityexp"
        ) + unityStreamingAssetsList

        ignoreAssetsPattern = "!.svn:!.git:!.ds_store:!*.scc:!CVS:!thumbs.db:!picasa.ini:!*~"
    }
}

// Add this new added at 12/01/2026:
flutter {
    source = "../.."
}

dependencies {
    implementation (project(":unityLibrary")) 
    // {
    //     // Exclude ARCore from Unity to avoid duplicate classes
    //     exclude(group = "com.google.ar", module = "core")
    // }
    // ARCore (Google Play Services for AR) library.
    // implementation("com.google.ar:core:1.52.0")

    // // Obj - a simple Wavefront OBJ file loader
    // implementation("de.javagl:obj:0.4.0")

    // implementation("androidx.appcompat:appcompat:1.6.1")
    // implementation("com.google.android.material:material:1.11.0")
}

