package com.wavelog_mobile

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {

    // Single-thread executor keeps encoder calls serial without blocking the UI thread
    private val encoderThread = Executors.newSingleThreadExecutor()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

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
    }
}
