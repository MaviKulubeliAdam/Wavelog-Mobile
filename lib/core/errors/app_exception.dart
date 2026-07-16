abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'İnternet bağlantısı yok'])
      : super(code: 'NETWORK_ERROR');
}

class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Bağlantı zaman aşımına uğradı'])
      : super(code: 'TIMEOUT');
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Geçersiz API anahtarı'])
      : super(code: 'UNAUTHORIZED');
}

class ServerException extends AppException {
  final int? statusCode;
  const ServerException(super.message, {this.statusCode})
      : super(code: 'SERVER_ERROR');
}

class ParseException extends AppException {
  const ParseException([super.message = 'Yanıt ayrıştırılamadı'])
      : super(code: 'PARSE_ERROR');
}

class AdifParseException extends AppException {
  final int? lineNumber;
  const AdifParseException(super.message, {this.lineNumber})
      : super(code: 'ADIF_PARSE_ERROR');
}

class LocalStorageException extends AppException {
  const LocalStorageException([super.message = 'Yerel depolama hatası'])
      : super(code: 'LOCAL_STORAGE_ERROR');
}

class ValidationException extends AppException {
  const ValidationException(super.message)
      : super(code: 'VALIDATION_ERROR');
}
