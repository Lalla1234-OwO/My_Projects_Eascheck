plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {

    compileSdkVersion 33            // ควรอัปเป็น API 33 (Android 13) เพื่อใช้ SDK ตัวล่าสุด

    defaultConfig {
        applicationId "com.example.eascheck"   // เปลี่ยนเป็น Bundle ID จริงของคุณ
        minSdkVersion 21                       // ถ้าต้องการใช้ plugin กล้อง + storage พื้นฐาน ให้ 21 ขึ้นไป  
                                                // ถ้าใช้ Android 13 storage-permission แยก (READ_MEDIA_IMAGES) ก็ยังใช้ 21 ได้  
        targetSdkVersion 33                    // ทดสอบกับ Android 13  
        versionCode 1
        versionName "1.0"
    }

    // ถ้าคุณใช้ Java 11+ หรือ Kotlin DSL อาจต้องเพิ่ม compileOptions / kotlinOptions
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
    
    namespace = "com.fluttermapp.eascheck"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.fluttermapp.eascheck"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
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
}

flutter {
    source = "../.."
}
