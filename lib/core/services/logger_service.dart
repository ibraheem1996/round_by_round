// Package imports:
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      // excludePaths: ['package:my_project/core/services/logger_service.dart'],
      stackTraceBeginIndex: 1,
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 180,
      colors: true,
      printEmojis: true,
      // dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      levelEmojis: {
        Level.trace: '🔍',
        Level.debug: '🐛',
        Level.info: 'ℹ️',
        Level.warning: '⚠️',
        Level.error: '❌',
        Level.fatal: '💥',
      },
    ),
  );

  static void debug(String message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      _logger.w(message);
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }
}
