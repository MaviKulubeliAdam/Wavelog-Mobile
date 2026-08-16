package com.wavelog_mobile

import android.media.MediaCodec
import android.media.MediaCodecInfo
import android.media.MediaFormat
import android.media.MediaMuxer
import java.io.File

object VideoEncoderPlugin {

    private var encoder: MediaCodec? = null
    private var muxer: MediaMuxer? = null
    private var videoTrack = -1
    private var muxerStarted = false
    private var presentationUs = 0L
    private var frameIntervalUs = 0L
    private var encWidth = 0
    private var encHeight = 0
    private val bufferInfo = MediaCodec.BufferInfo()

    fun initEncoder(w: Int, h: Int, fps: Int, outputPath: String) {
        release()

        // MediaCodec requires even dimensions
        encWidth  = if (w % 2 == 0) w else w - 1
        encHeight = if (h % 2 == 0) h else h - 1
        frameIntervalUs = 1_000_000L / fps
        presentationUs  = 0L

        val mime   = MediaFormat.MIMETYPE_VIDEO_AVC
        val format = MediaFormat.createVideoFormat(mime, encWidth, encHeight).apply {
            setInteger(MediaFormat.KEY_COLOR_FORMAT,
                MediaCodecInfo.CodecCapabilities.COLOR_FormatYUV420SemiPlanar)
            setInteger(MediaFormat.KEY_BIT_RATE, 4_000_000)
            setInteger(MediaFormat.KEY_FRAME_RATE, fps)
            setInteger(MediaFormat.KEY_I_FRAME_INTERVAL, 1)
        }

        val enc = MediaCodec.createEncoderByType(mime)
        enc.configure(format, null, null, MediaCodec.CONFIGURE_FLAG_ENCODE)
        enc.start()
        encoder = enc

        File(outputPath).delete()
        muxer = MediaMuxer(outputPath, MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4)
    }

    fun addFrame(rgba: ByteArray) {
        val enc = encoder ?: error("Encoder not initialized — call initEncoder first")
        val nv12 = rgbaToNV12(rgba)

        // Get an input buffer, draining output while we wait
        var inputIdx = -1
        while (inputIdx < 0) {
            inputIdx = enc.dequeueInputBuffer(10_000L)
            if (inputIdx < 0) drainOutput(false)
        }

        enc.getInputBuffer(inputIdx)!!.let { buf ->
            buf.clear()
            buf.put(nv12)
        }
        enc.queueInputBuffer(inputIdx, 0, nv12.size, presentationUs, 0)
        presentationUs += frameIntervalUs

        drainOutput(false)
    }

    fun finalizeEncoder() {
        val enc = encoder ?: return

        // Signal end-of-stream with an empty input buffer
        var inputIdx = -1
        while (inputIdx < 0) {
            inputIdx = enc.dequeueInputBuffer(10_000L)
            if (inputIdx < 0) drainOutput(false)
        }
        enc.queueInputBuffer(inputIdx, 0, 0, presentationUs,
            MediaCodec.BUFFER_FLAG_END_OF_STREAM)
        drainOutput(true)

        release()
    }

    private fun drainOutput(endOfStream: Boolean) {
        val enc = encoder ?: return
        val mux = muxer  ?: return

        while (true) {
            val idx = enc.dequeueOutputBuffer(bufferInfo,
                if (endOfStream) 100_000L else 0L)
            when {
                idx == MediaCodec.INFO_TRY_AGAIN_LATER -> {
                    if (!endOfStream) break
                    // Keep looping until EOS arrives
                }
                idx == MediaCodec.INFO_OUTPUT_FORMAT_CHANGED -> {
                    check(!muxerStarted) { "Format changed after muxer started" }
                    videoTrack = mux.addTrack(enc.outputFormat)
                    mux.start()
                    muxerStarted = true
                }
                idx >= 0 -> {
                    val outBuf = enc.getOutputBuffer(idx)!!
                    val isConfig = bufferInfo.flags and
                            MediaCodec.BUFFER_FLAG_CODEC_CONFIG != 0
                    if (!isConfig && bufferInfo.size > 0 && muxerStarted) {
                        outBuf.position(bufferInfo.offset)
                        outBuf.limit(bufferInfo.offset + bufferInfo.size)
                        mux.writeSampleData(videoTrack, outBuf, bufferInfo)
                    }
                    enc.releaseOutputBuffer(idx, false)
                    if (bufferInfo.flags and MediaCodec.BUFFER_FLAG_END_OF_STREAM != 0)
                        return
                }
            }
        }
    }

    private fun release() {
        try { encoder?.stop()    } catch (_: Exception) {}
        try { encoder?.release() } catch (_: Exception) {}
        encoder = null
        try { if (muxerStarted) muxer?.stop() } catch (_: Exception) {}
        try { muxer?.release()  } catch (_: Exception) {}
        muxer        = null
        muxerStarted = false
        videoTrack   = -1
    }

    /**
     * Converts Flutter raw RGBA bytes to NV12 (YUV420 semi-planar).
     * Flutter's ImageByteFormat.rawRgba packs pixels as R G B A in memory order.
     */
    private fun rgbaToNV12(rgba: ByteArray): ByteArray {
        val w   = encWidth
        val h   = encHeight
        val yuv = ByteArray(w * h * 3 / 2)
        var yIdx  = 0
        var uvIdx = w * h

        for (j in 0 until h) {
            for (i in 0 until w) {
                val off = (j * w + i) * 4
                val r = rgba[off    ].toInt() and 0xFF
                val g = rgba[off + 1].toInt() and 0xFF
                val b = rgba[off + 2].toInt() and 0xFF

                yuv[yIdx++] = (((66 * r + 129 * g + 25 * b + 128) shr 8) + 16)
                    .coerceIn(0, 255).toByte()

                if (j % 2 == 0 && i % 2 == 0) {
                    yuv[uvIdx++] = (((-38 * r - 74 * g + 112 * b + 128) shr 8) + 128)
                        .coerceIn(0, 255).toByte()
                    yuv[uvIdx++] = (((112 * r - 94 * g - 18 * b + 128) shr 8) + 128)
                        .coerceIn(0, 255).toByte()
                }
            }
        }
        return yuv
    }
}
