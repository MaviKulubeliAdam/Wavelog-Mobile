# Flutter
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.**

# Google Play Core is referenced by Flutter's embedding for deferred
# components (dynamic feature delivery), which this app doesn't use.
# Not a real dependency here — let R8 treat calls as dead code so the
# classes are stripped from the F-Droid build.
-dontwarn com.google.android.play.**
-assumenosideeffects class io.flutter.embedding.engine.deferredcomponents.PlayStoreDeferredComponentManager {
    *;
}
-assumenosideeffects class com.google.android.play.core.** {
    *;
}

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

# Keep data models (ADIF/QSO serialization)
-keep class com.wavelog_mobile.** { *; }
