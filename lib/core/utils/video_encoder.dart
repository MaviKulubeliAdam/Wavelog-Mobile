import 'dart:typed_data';
import 'package:flutter/services.dart';

class VideoEncoder {
  static const _ch = MethodChannel('com.wavelog_mobile/video_encoder');

  static Future<void> initEncoder({
    required int width,
    required int height,
    required int fps,
    required String outputPath,
  }) =>
      _ch.invokeMethod<void>('initEncoder', {
        'width': width,
        'height': height,
        'fps': fps,
        'outputPath': outputPath,
      });

  /// One frame's raw RGBA bytes directly from RenderRepaintBoundary.toImage.
  static Future<void> addFrame(Uint8List rgbaBytes) =>
      _ch.invokeMethod<void>('addFrame', rgbaBytes);

  static Future<void> finalizeEncoder() =>
      _ch.invokeMethod<void>('finalizeEncoder');
}
