package com.wavelog_mobile

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {

    private val encoderThread = Executors.newSingleThreadExecutor()

    private var pendingFileName: String? = null
    private var pendingFileContent: String? = null
    private var intentChannel: MethodChannel? = null

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
}
