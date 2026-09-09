# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.**

# Kotlin coroutines
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembernames class kotlinx.** { volatile <fields>; }
-dontwarn kotlinx.coroutines.**

# Hive
-keep class com.hive.** { *; }
-keep class ** implements com.hive.TypeAdapter { *; }
-keepclassmembers class * {
    @com.hive.annotations.HiveType *;
    @com.hive.annotations.HiveField *;
}

# Dio / OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Gson / JSON serialization
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory { *; }
-keep class * implements com.google.gson.JsonSerializer { *; }
-keep class * implements com.google.gson.JsonDeserializer { *; }

# SharedPreferences
-keep class androidx.preference.** { *; }

# FlutterSecureStorage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Geolocator
-keep class com.baseflow.geolocator.** { *; }

# Keep data models (ADIF/QSO serialization)
-keep class com.wavelog_mobile.** { *; }
