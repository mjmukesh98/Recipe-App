import 'package:demo/core/utils/AppLogger.dart';
import 'package:dio/dio.dart';

class ErrorHandler {
  static String handle(dynamic error) {
    if (error is DioException) {
      final url = error.requestOptions.uri.toString();

      if (error.response != null) {
        final data = error.response!.data;
        final statusCode = error.response!.statusCode;
        final serverMessage = (data is Map && data["message"] != null)
            ? data["message"].toString()
            : "Something went wrong";

        // Log API responses that returned an error status code (e.g., 400, 404, 500)
        AppLogger.error(
          url,
          "API Error Response: $serverMessage",
          statusCode: statusCode,
          exception: error,
          stackTrace: error.stackTrace,
        );

        return serverMessage;
      }

      // Log network timeouts, connection losses, or cancellations
      String networkMessage;
      switch (error.type) {
        case DioExceptionType.connectionError:
          networkMessage = "No internet connection";
          break;
        case DioExceptionType.connectionTimeout:
          networkMessage = "Connection timeout";
          break;
        default:
          networkMessage = "Network error (${error.type.name})";
          break;
      }

      AppLogger.error(
        url,
        "Network Failure: $networkMessage",
        exception: error,
        stackTrace: error.stackTrace,
      );

      return networkMessage;
    }

    // Log unexpected code exceptions (e.g., type casting, null pointers)
    AppLogger.error(
      "Unknown URL",
      "Unexpected System Error",
      exception: error,
      stackTrace: error is Error ? error.stackTrace : StackTrace.current,
    );

    return "Unexpected error occurred";
  }
}
