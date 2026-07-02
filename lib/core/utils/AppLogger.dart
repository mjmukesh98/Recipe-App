import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void request(
    String url, {
    String method = 'GET',
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    _logger.i(
      '🚀 [API REQUEST]\n'
      'Method: $method\n'
      'URL: $url\n'
      'Headers: ${headers ?? "None"}\n'
      'Body: ${body ?? "Empty"}',
    );
  }

  static void response(String url, int statusCode, dynamic data) {
    _logger.d(
      '✅ [API RESPONSE]\n'
      'URL: $url\n'
      'Status Code: $statusCode\n'
      'Data: $data',
    );
  }

  static void error(
    String url,
    String errorMessage, {
    int? statusCode,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    _logger.e(
      '❌ [API ERROR]\n'
      'URL: $url\n'
      'Status Code: ${statusCode ?? "N/A"}\n'
      'Error: $errorMessage',
      error: exception,
      stackTrace: stackTrace,
    );
  }
}
