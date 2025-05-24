import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("keystore.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.kanji_app"
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
        applicationId = "com.example.kanji_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        register("tst") {
            storeFile = file(keystoreProperties.getProperty("tst.storeFile"))
            storePassword = keystoreProperties.getProperty("tst.storePassword")
            keyAlias = keystoreProperties.getProperty("tst.keyAlias")
            keyPassword = keystoreProperties.getProperty("tst.keyPassword")
        }
    }

    buildTypes {
        release {
            isDebuggable = false
            isMinifyEnabled = true
            isShrinkResources = true
        }

        debug {
            isDebuggable = true
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = null
        }
    }

    flavorDimensions += "environment"

    val baseAppName = "Kanji Dictionary"

    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            manifestPlaceholders["appName"] = "$baseAppName DEV"
            signingConfig = signingConfigs.getByName("tst")
        }

        create("tst") {
            dimension = "environment"
            applicationIdSuffix = ".tst"
            manifestPlaceholders["appName"] = "$baseAppName TST"
            signingConfig = signingConfigs.getByName("tst")
        }
    }
}

flutter {
    source = "../.."
}
