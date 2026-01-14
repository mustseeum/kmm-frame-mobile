# Unity Configuration Guide for flutter_embed_unity

*Last Updated: January 2025*  
*Plugin Version: flutter_embed_unity ^1.3.1*

---

## 1. Prerequisites

Before configuring Unity, ensure you have:
- **Unity 6000.0 LTS** installed
- A **Flutter project** ready for integration
- For AR support: **ARFoundation**, **ARKit (iOS)**, and/or **ARCore (Android)** configured in Unity

> ⚠️ **Important**: Only specific Unity versions are supported. Using unsupported versions may cause crashes.

---

## 2. Create or Open a Unity Project

1. Open Unity Hub and create a new project using the **3D (URP) Core** template **or** open an existing project
2. Ensure your project uses the **Universal Render Pipeline (URP)**

---

## 3. Switch Build Platform

### For Android:
- Go to **File > Build Profiles** (Unity 6000.0)
- Select **Android**, then click **Switch Platform**

## 4. Configure Player Settings

Navigate to **File > Build Settings > Player Settings > Other Settings** and apply the following:

### Common Settings (Both Platforms)
| Setting | Value |
|--------|-------|
| **Identification > Minimum API Level** | `API level 24` |
| **Identification > Target API Level** | `Automatice (Highest installed)` |
| **Scripting Backend** | `IL2CPP` |
| **Target Architectures** | ARMv7 + ARM64 (Android)<br>ARM64 (iOS) |

> ✅ Google Play requires 64-bit apps → ARM64 is mandatory.

### Optional (Performance vs Debug)
- For **Release Builds**:
  - **IL2CPP Code Generation**: `Faster runtime`
  - **C++ Compiler Configuration**: `Release`
- For **Development**:
  - **IL2CPP Code Generation**: `Faster build`
  - **C++ Compiler Configuration**: `Debug`

---

## 5. Import the Plugin Unity Package

1. Go to the [GitHub Releases](https://github.com/jamesncl/flutter_embed_unity/releases) of `flutter_embed_unity`
2. Download the correct `.unitypackage`:
   - `flutter_embed_unity_2022_3.unitypackage` → for Unity 2022.3
   - `flutter_embed_unity_6000_0.unitypackage` → for Unity 6000.0 **project recommended**
3. In Unity, go to **Assets > Import Package > Custom Package** and select the downloaded file
4. Import both folders:
   - **`FlutterEmbed`** (required)
   - **`Example`** (optional; includes demo scenes)

> 📌 The `FlutterEmbed` folder contains essential scripts like `SendToFlutter.cs`.

---

## 6. Set Up Messaging (Optional but Recommended)

### To Receive Messages from Flutter
Attach a `MonoBehaviour` script to a GameObject with a **public method** that takes one `string` parameter:

```csharp
public class MyController : MonoBehaviour {
    public void SetRotationSpeed(string data) {
        float speed = float.Parse(data, CultureInfo.InvariantCulture);
        // Use speed...
    }
}