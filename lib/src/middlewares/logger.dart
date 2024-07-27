import 'dart:io';

import '../middleware.dart';
import '../request.dart';
import '../response.dart';

/// A factory for creating a logger middleware.
///
/// This middleware logs each request and response to a log file located in the `logs` directory.
class LoggerMiddlewareFactory implements MiddlewareFactory {
  @override
  Middleware create() {
    return (Request request, Response response,
        void Function(Request req, Response res) next) {
      _ensureLogsDirExists();

      final Directory logsDir = _getLogsDir();
      final File logsFile =
          File("${logsDir.path}${Platform.pathSeparator}server_logs.log");
      final IOSink cursor = logsFile.openWrite(mode: FileMode.append);

      cursor.writeln("[${request.method}] ${DateTime.now()}: ${request.uri}");

      next(request, response);

      cursor.writeln(
          "[${request.method}] ${DateTime.now()}: ${request.uri} ${response.statusCode}");
      cursor.flush().then((_) => cursor.close());
    };
  }

  /// Checks if the `logs` directory exists and creates it if it does not.
  void _ensureLogsDirExists() {
    final Directory logsDir = _getLogsDir();
    if (!logsDir.existsSync()) {
      logsDir.createSync(recursive: true);
    }
  }

  /// Gets the `logs` directory.
  ///
  /// Returns a [Directory] object representing the `logs` directory.
  Directory _getLogsDir() {
    return Directory("${Directory.current.path}${Platform.pathSeparator}logs");
  }
}
