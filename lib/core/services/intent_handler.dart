import 'package:flutter/services.dart';
import '../../router.dart';

typedef AdifFileData = ({String name, String content});

class IntentHandler {
  IntentHandler._();

  static const _ch = MethodChannel('com.wavelog_mobile/intent_handler');

  /// main() içinden çağrılır.
  /// Uygulama açıkken gelen ACTION_VIEW intent'ini yakalar ve /adif'e yönlendirir.
  static void initialize() {
    _ch.setMethodCallHandler((call) async {
      if (call.method == 'onNewFile' && call.arguments != null) {
        final args = Map<String, dynamic>.from(call.arguments as Map);
        appRouter.push(
          '/adif',
          extra: (
            name: args['name'] as String,
            content: args['content'] as String,
          ),
        );
      }
    });
  }

  /// SplashScreen'den çağrılır.
  /// Uygulama kapalıyken ACTION_VIEW ile açılan dosyayı döndürür; yoksa null.
  static Future<AdifFileData?> getInitialFile() async {
    final r = await _ch.invokeMapMethod<String, dynamic>('getInitialFile');
    if (r == null) return null;
    return (name: r['name'] as String, content: r['content'] as String);
  }
}
