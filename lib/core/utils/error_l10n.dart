import 'package:flutter/widgets.dart';
import '../errors/app_exception.dart';
import 'l10n_extension.dart';

/// Bilinen uygulama hatalarını kullanıcının diline çevirir.
/// AppException dışındaki hatalar için toString() döner.
String localizeError(BuildContext context, Object error) {
  final l10n = context.l10n;
  if (error is TimeoutException) return l10n.errTimeout;
  if (error is UnauthorizedException) return l10n.errUnauthorized;
  if (error is NetworkException) return l10n.errNetwork;
  return error.toString();
}
