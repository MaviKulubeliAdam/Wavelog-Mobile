package com.wavelog_mobile

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.provider.OpenableColumns
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {

    private val encoderThread = Executors.newSingleThreadExecutor()

    private var pendingFileName: String? = null
    private var pendingFileContent: String? = null
    private var intentChannel: MethodChannel? = null

    private var pendingLocationPermissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ── VideoEncoder channel (unchanged) ────────────────────────────
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.wavelog_mobile/video_encoder"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "initEncoder" -> encoderThread.submit {
                    try {
                        VideoEncoderPlugin.initEncoder(
                            w          = call.argument<Int>("width")!!,
                            h          = call.argument<Int>("height")!!,
                            fps        = call.argument<Int>("fps")!!,
                            outputPath = call.argument<String>("outputPath")!!
                        )
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("INIT_ERROR", e.message, null)
                    }
                }
                "addFrame" -> encoderThread.submit {
                    try {
                        VideoEncoderPlugin.addFrame(call.arguments as ByteArray)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("FRAME_ERROR", e.message, null)
                    }
                }
                "finalizeEncoder" -> encoderThread.submit {
                    try {
                        VideoEncoderPlugin.finalizeEncoder()
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("FINALIZE_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        // ── Intent handler channel ───────────────────────────────────────
        intentChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.wavelog_mobile/intent_handler"
        ).also { ch ->
            ch.setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialFile" -> {
                        val name    = pendingFileName
                        val content = pendingFileContent
                        if (name != null && content != null) {
                            pendingFileName    = null
                            pendingFileContent = null
                            result.success(mapOf("name" to name, "content" to content))
                        } else {
                            result.success(null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
        }

        // ── Native location channel (GMS-free, F-Droid build) ────────────
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.wavelog_mobile/location"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkPermission" -> result.success(currentLocationPermission())
                "requestPermission" -> requestLocationPermission(result)
                "getCurrentPosition" -> getCurrentLocation(result)
                else -> result.notImplemented()
            }
        }
    }

    private fun currentLocationPermission(): String {
        val fine = ContextCompat.checkSelfPermission(
            this, Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
        val coarse = ContextCompat.checkSelfPermission(
            this, Manifest.permission.ACCESS_COARSE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
        return if (fine || coarse) "whileInUse" else "denied"
    }

    private fun requestLocationPermission(result: MethodChannel.Result) {
        if (currentLocationPermission() == "whileInUse") {
            result.success("whileInUse")
            return
        }
        pendingLocationPermissionResult = result
        ActivityCompat.requestPermissions(
            this,
            arrayOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ),
            LOCATION_PERMISSION_REQUEST_CODE
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == LOCATION_PERMISSION_REQUEST_CODE) {
            val granted = grantResults.isNotEmpty() &&
                grantResults[0] == PackageManager.PERMISSION_GRANTED
            pendingLocationPermissionResult?.success(if (granted) "whileInUse" else "denied")
            pendingLocationPermissionResult = null
        }
    }

    private fun getCurrentLocation(result: MethodChannel.Result) {
        if (currentLocationPermission() == "denied") {
            result.error("PERMISSION_DENIED", "Location permission not granted", null)
            return
        }

        val locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
        val provider = when {
            locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) ->
                LocationManager.GPS_PROVIDER
            locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER) ->
                LocationManager.NETWORK_PROVIDER
            else -> null
        }
        if (provider == null) {
            result.error("LOCATION_DISABLED", "No location provider available", null)
            return
        }

        var resultSent = false
        val listener = object : LocationListener {
            override fun onLocationChanged(location: Location) {
                if (resultSent) return
                resultSent = true
                locationManager.removeUpdates(this)
                result.success(mapOf("latitude" to location.latitude, "longitude" to location.longitude))
            }
            @Deprecated("Deprecated in Java")
            override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}
            override fun onProviderEnabled(provider: String) {}
            override fun onProviderDisabled(provider: String) {}
        }

        try {
            locationManager.requestLocationUpdates(provider, 0L, 0f, listener, Looper.getMainLooper())
        } catch (e: SecurityException) {
            result.error("PERMISSION_DENIED", e.message, null)
            return
        }

        Handler(Looper.getMainLooper()).postDelayed({
            if (!resultSent) {
                resultSent = true
                locationManager.removeUpdates(listener)
                val last = try {
                    locationManager.getLastKnownLocation(provider)
                        ?: locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER)
                        ?: locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)
                } catch (e: SecurityException) {
                    null
                }
                if (last != null) {
                    result.success(mapOf("latitude" to last.latitude, "longitude" to last.longitude))
                } else {
                    result.error("TIMEOUT", "Could not get location", null)
                }
            }
        }, LOCATION_TIMEOUT_MS)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleViewIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (handleViewIntent(intent)) {
            // Engine may not be ready yet — guard with null check
            intentChannel?.invokeMethod(
                "onNewFile",
                mapOf("name" to pendingFileName!!, "content" to pendingFileContent!!)
            )
            pendingFileName    = null
            pendingFileContent = null
        }
    }

    private fun handleViewIntent(intent: Intent?): Boolean {
        if (intent?.action != Intent.ACTION_VIEW) return false
        val uri = intent.data ?: return false
        val name = getDisplayName(uri)
        val ext  = name.substringAfterLast('.', "").lowercase()
        if (ext != "adi" && ext != "adif") return false
        return try {
            val text = contentResolver.openInputStream(uri)
                ?.bufferedReader()
                ?.use { it.readText() }
                ?: return false
            pendingFileName    = name
            pendingFileContent = text
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun getDisplayName(uri: Uri): String {
        contentResolver.query(uri, null, null, null, null)?.use { cursor ->
            val col = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
            if (col >= 0 && cursor.moveToFirst()) {
                cursor.getString(col)?.let { return it }
            }
        }
        return uri.lastPathSegment ?: "import.adif"
    }

    companion object {
        private const val LOCATION_PERMISSION_REQUEST_CODE = 9001
        private const val LOCATION_TIMEOUT_MS = 15000L
    }
}
