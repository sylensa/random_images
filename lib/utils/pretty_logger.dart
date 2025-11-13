import 'dart:convert';
import 'dart:developer' as developer;

/// A utility class for pretty-printing logs, especially JSON data
class PrettyLogger {
  /// Logs a message with optional JSON pretty-printing
  ///
  /// If [message] contains valid JSON string, it will be formatted with indentation.
  /// If [data] is provided (Map, List, or JSON-serializable object), it will be pretty-printed.
  ///
  /// Example:
  /// ```dart
  /// prettyLog('API Response', data: responseBody);
  /// prettyLog('User data: $jsonString');
  /// ```
  static void prettyLog(
    String message, {
    dynamic data,
    String name = 'PrettyLog',
    int indent = 2,
  }) {
    try {
      String output = message;

      // If data is provided, try to pretty-print it
      if (data != null) {
        output = _formatWithData(message, data, indent);
      } else {
        // Try to find and pretty-print JSON in the message string
        output = _tryPrettyPrintInMessage(message, indent);
      }

      developer.log(output, name: name);
    } catch (e) {
      // If anything fails, just log the original message
      developer.log(message, name: name);
    }
  }

  /// Formats message with data object
  static String _formatWithData(String message, dynamic data, int indent) {
    try {
      String prettyJson;

      if (data is String) {
        // If it's a string, try to parse it as JSON
        try {
          final decoded = jsonDecode(data);
          prettyJson = _prettyPrintJson(decoded, indent);
        } catch (_) {
          // If it's not valid JSON, use it as-is
          prettyJson = data;
        }
      } else if (data is Map || data is List) {
        // If it's already a Map or List, pretty-print it
        prettyJson = _prettyPrintJson(data, indent);
      } else {
        // For other types, convert to string
        prettyJson = data.toString();
      }

      return '$message\n$prettyJson';
    } catch (e) {
      return '$message\n${data.toString()}';
    }
  }

  /// Tries to find and pretty-print JSON within a message string
  static String _tryPrettyPrintInMessage(String message, int indent) {
    // Look for JSON patterns in the message
    final jsonPatterns = [
      RegExp(r'\{.*\}', dotAll: true),
      RegExp(r'\[.*\]', dotAll: true),
    ];

    for (final pattern in jsonPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final possibleJson = match.group(0);
        try {
          final decoded = jsonDecode(possibleJson!);
          final prettyJson = _prettyPrintJson(decoded, indent);
          return message.replaceAll(possibleJson, '\n$prettyJson');
        } catch (_) {
          // Not valid JSON, continue
        }
      }
    }

    return message;
  }

  /// Pretty-prints a JSON object with indentation
  static String _prettyPrintJson(dynamic json, int indent) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }
}

/// Convenience function for quick logging
///
/// Usage:
/// ```dart
/// prettyLog('API Response', data: response.body);
/// prettyLog('User: $userJson');
/// ```
void prettyLog(String message, {dynamic data, String name = 'App'}) {
  PrettyLogger.prettyLog(message, data: data, name: name);
}

/// Specialized loggers for different purposes
class ApiLogger {
  static void logRequest(String url, {Map<String, dynamic>? headers, dynamic body}) {
    prettyLog('🌐 API REQUEST', data: {
      'url': url,
      'headers': headers,
      'body': body,
    }, name: 'API-Request');
  }

  static void logResponse(int? statusCode, {dynamic body}) {
    prettyLog('📥 API RESPONSE', data: {
      'statusCode': statusCode,
      'body': body,
    }, name: 'API-Response');
  }

  static void logError(String message, {dynamic error}) {
    prettyLog('❌ API ERROR: $message', data: error, name: 'API-Error');
  }
}

class StateLogger {
  static void logState(String stateName, {dynamic data}) {
    prettyLog('🔄 STATE: $stateName', data: data, name: 'State');
  }

  static void logError(String stateName, {dynamic error}) {
    prettyLog('❌ STATE ERROR: $stateName', data: error, name: 'State-Error');
  }
}

class DebugLogger {
  static void log(String message, {dynamic data}) {
    prettyLog('🐛 DEBUG: $message', data: data, name: 'Debug');
  }
}
