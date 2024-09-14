import 'dart:async';
import 'dart:developer' as developer;
import 'package:development_skeleton/utils/utils.dart';
import 'package:logger/logger.dart';

typedef OnCollectCallback = FutureOr<void> Function(LogLevel level, List<String> lines);

enum LogLevel {
  trace,
  debug,
  info,
  warning,
  error,
}

abstract class Log {

  /// assert(() {
  ///   // ...debug-only code here...
  ///   return true;
  /// }());

  static bool enableConsole = isDebug;
  static OnCollectCallback? onCollect;

  static Level _level = Level.trace;

  static set logLevel(LogLevel level) {
    _level = enumFromString<Level>(Level.values, enumToString(level));
  }

  static Logger? _loggerInstance;

  static Logger get _logger {
    if (null == _loggerInstance) {
      var outputs = <LogOutput>[];
      if (enableConsole) {
        outputs.add(ConsoleOutput());
      }

      if (onCollect != null) {
        outputs.add(CollectorOutput(onCollect!));
      }

      _loggerInstance = Logger(
        level: _level,
        filter: ProductionFilter(),
        printer: _Printer(),
        output: MultiOutput(outputs),
      );
    }

    return _loggerInstance!;
  }

  /// Log a message at level [Level.trace].
  static void v(dynamic message, [StackTrace? stackTrace]) {
    _logger.t(message, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.debug].
  static void d(dynamic message, [StackTrace? stackTrace]) {
    _logger.d(message, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.info].
  static void i(dynamic message, [StackTrace? stackTrace]) {
    _logger.i(message, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.warning].
  static void w(dynamic message, [StackTrace? stackTrace]) {
    _logger.w(message, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.error].
  static void e(dynamic message, [StackTrace? stackTrace]) {
    _logger.e(message, stackTrace: stackTrace);
  }

}

Map<Level, String> _levelNames = {
  Level.trace: 'trace',
  Level.debug: 'Debug',
  Level.info: 'Info',
  Level.warning: 'Warning',
  Level.error: 'Error',
};

class _Printer extends PrettyPrinter {
  // ignore: use_super_parameters
  _Printer({
    stackTraceBeginIndex = 0,
    errorMethodCount = 30,
  }) : super(
    stackTraceBeginIndex: stackTraceBeginIndex,
    errorMethodCount: errorMethodCount,
  );

  @override
  List<String> log(LogEvent event) {
    var messageStr = stringifyMessage(event.message);

    String? stackTraceStr;
    if (event.stackTrace != null && errorMethodCount! > 0) {
      stackTraceStr = formatStackTrace(event.stackTrace, errorMethodCount);
    }

    var errorStr = event.error?.toString();

    return _formatAndPrint(
      event.level,
      messageStr,
      errorStr,
      stackTraceStr,
    );
  }

  List<String> _formatAndPrint(
      Level level,
      String message,
      String? error,
      String? stacktrace,
      ) {
    List<String> buffer = [];

    DateTime date = DateTime.now();
    String time = '${date.hour}:${date.minute}:${date.second}';

    String prefix = '[${_levelNames[level]!}] [$time]';

    // format message
    for (var line in message.split('\n')) {
      buffer.add('$prefix $line');
    }

    if (error != null) {
      for (var line in error.split('\n')) {
        buffer.add('$prefix $line');
      }
    }

    if (stacktrace != null) {
      for (var line in stacktrace.split('\n')) {
        buffer.add('$prefix $line');
      }
    }

    return buffer;
  }
}

class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var element in event.lines) {
      developer.log(element.replaceAll(RegExp(r'^\[\w+\]\s+'), ''), name: _levelNames[event.level]!);
    }
  }
}

class CollectorOutput extends LogOutput {
  final OnCollectCallback onCollect;

  CollectorOutput(this.onCollect);

  @override
  void output(OutputEvent event) {
    onCollect(
      enumFromString<LogLevel>(LogLevel.values, enumToString(event.level)),
      event.lines,
    );
  }
}



/// Enum to string
///
/// ```
/// enum MyEnum {A, B, C}
/// String e = enumToString(MyEnum.B);
/// print(e); // is B
/// ```
String enumToString(obj) => obj.toString().split('.').last;

/// Enum from string
///
/// ```
/// enum MyEnum {A, B, C}
/// MyEnum e = enumFromString<MyEnum>(MyEnum.values, 'B');
/// print(e); // is MyEnum.B
/// ```
T enumFromString<T>(Iterable<T> values, String value) {
  return values.firstWhere((type) => type.toString().split('.').last == value,
      orElse: () {
        throw 'Undefined enumeration type!';
      });
}