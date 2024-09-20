import 'package:logger/logger.dart';

abstract class Log {
  /// 详细日志（包含时间、打印位置、内容）
  static Logger? _detailLogger;

  /// 简单日志（包含时间、内容）
  static Logger? _simpleLogger;

  /// 日志颜色
  static final Map<Level, AnsiColor> colorOfLevel = {
    Level.trace: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: const AnsiColor.none(),
    Level.info: const AnsiColor.fg(12),
    Level.warning: const AnsiColor.fg(208),
    Level.error: const AnsiColor.fg(196),
    Level.fatal: const AnsiColor.fg(199),
  };

  Log._();

  static Logger get _loggerDetail {
    _detailLogger ??= Logger(
      printer: PrettyPrinter(
        printEmojis: false,
        dateTimeFormat: DateTimeFormat.dateAndTime,
        stackTraceBeginIndex: 1,
        methodCount: 2,
      ),
      // printer: _Printer(),
      output: MultiOutput([ConsoleOutput()]),
    );
    return _detailLogger!;
  }

  static Logger get _loggerSimple {
    _simpleLogger ??= Logger(
      printer: _Printer(colorOfLevel),
      // printer: _Printer(),
      output: MultiOutput([ConsoleOutput()]),
    );
    return _simpleLogger!;
  }

  ///# 打印日志
  ///
  ///## 说明：打印详细日志，等级[Level.trace]。包含时间、打印位置、内容
  ///
  ///┌───────────────────────────────────────────────────────────────────────────────────
  ///│ #1   SampleController.init (package:example/page/main/sample_controller.dart:35:9)
  ///├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  ///│ 2024-09-20 03:55:12.642
  ///├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  ///│ trace
  ///└───────────────────────────────────────────────────────────────────────────────────
  static void t(dynamic message, [StackTrace? stackTrace]) {
    _loggerDetail.t(message, stackTrace: stackTrace);
  }

  ///# 打印日志
  ///
  ///## 说明：打印简略日志，等级[Level.trace]。包含时间、内容
  ///
  ///[3:58:12]：trace
  static void simpleT(dynamic message, [StackTrace? stackTrace]) {
    _loggerSimple.t(message, stackTrace: stackTrace);
  }

  ///# 打印日志
  ///
  ///## 说明：打印详细日志，等级[Level.debug]。包含时间、打印位置、内容
  ///
  ///┌───────────────────────────────────────────────────────────────────────────────────
  ///│ #1   SampleController.init (package:example/page/main/sample_controller.dart:36:9)
  ///├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  ///│ 2024-09-20 03:58:47.763
  ///├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  ///│ debug
  ///└───────────────────────────────────────────────────────────────────────────────────
  static void d(dynamic message, [StackTrace? stackTrace]) {
    _loggerDetail.d(message, stackTrace: stackTrace);
  }

  ///# 打印日志
  ///
  ///## 说明：打印简略日志，等级[Level.debug]。包含时间、内容
  ///
  ///[3:58:12]：debug
  static void simpleD(dynamic message, [StackTrace? stackTrace]) {
    _loggerSimple.d(message, stackTrace: stackTrace);
  }

  ///# 打印日志
  ///
  ///## 说明：打印详细日志，等级[Level.info]。包含时间、打印位置、内容
  ///
  ///┌───────────────────────────────────────────────────────────────────────────────────
  ///│ #1   SampleController.init (package:example/page/main/sample_controller.dart:37:9)
  ///├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  ///│ 2024-09-20 03:58:47.764
  ///├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  ///│ info
  ///└───────────────────────────────────────────────────────────────────────────────────
  static void i(dynamic message, [StackTrace? stackTrace]) {
    _loggerDetail.i(message, stackTrace: stackTrace);
  }

  ///# 打印日志
  ///
  ///## 说明：打印简略日志，等级[Level.info]。包含时间、内容
  ///
  ///[3:58:12]：info
  static void simpleI(dynamic message, [StackTrace? stackTrace]) {
    _loggerSimple.i(message, stackTrace: stackTrace);
  }

  ///# 打印日志
  ///
  ///## 说明：打印详细日志，等级[Level.warning]。包含时间、打印位置、内容
  ///
  ///┌───────────────────────────────────────────────────────────────────────────────────
  ///│ #1   SampleController.init (package:example/page/main/sample_controller.dart:38:9)
  ///├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  ///│ 2024-09-20 03:58:47.770
  ///├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  ///│ warning
  ///└───────────────────────────────────────────────────────────────────────────────────
  static void w(dynamic message, [StackTrace? stackTrace]) {
    _loggerDetail.w(message, stackTrace: stackTrace);
  }

  ///# 打印日志
  ///
  ///## 说明：打印简略日志，等级[Level.warning]。包含时间、内容
  ///
  ///[3:58:12]：warning
  static void simpleW(dynamic message, [StackTrace? stackTrace]) {
    _loggerSimple.w(message, stackTrace: stackTrace);
  }

  ///# 打印日志
  ///
  ///## 说明：打印详细日志，等级[Level.error]。包含时间、打印位置、内容
  ///
  ///┌───────────────────────────────────────────────────────────────────────────────────
  ///│ #1   SampleController.init (package:example/page/main/sample_controller.dart:39:9)
  ///├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  ///│ 2024-09-20 03:58:47.773
  ///├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  ///│ error
  ///└───────────────────────────────────────────────────────────────────────────────────
  static void e(dynamic message, [StackTrace? stackTrace]) {
    _loggerDetail.e(message, stackTrace: stackTrace);
  }

  ///# 打印日志
  ///
  ///## 说明：打印简略日志，等级[Level.error]。包含时间、内容
  ///
  ///[3:58:12]：error
  static void simpleE(dynamic message, [StackTrace? stackTrace]) {
    _loggerSimple.e(message, stackTrace: stackTrace);
  }

  ///# 打印日志
  ///
  ///## 说明：打印详细日志，等级[Level.fatal]。包含时间、打印位置、内容
  ///
  ///┌───────────────────────────────────────────────────────────────────────────────────
  ///│ #1   SampleController.init (package:example/page/main/sample_controller.dart:40:9)
  ///├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  ///│ 2024-09-20 03:58:47.775
  ///├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  ///│ fatal
  ///└───────────────────────────────────────────────────────────────────────────────────
  static void f(dynamic message, [StackTrace? stackTrace]) {
    _loggerDetail.f(message, stackTrace: stackTrace);
  }

  ///# 打印日志
  ///
  ///## 说明：打印简略日志，等级[Level.fatal]。包含时间、内容
  ///
  ///[3:58:12]：fatal
  static void simpleF(dynamic message, [StackTrace? stackTrace]) {
    _loggerSimple.f(message, stackTrace: stackTrace);
  }
}

///# 日志打印
///
///## 说明：自定义简单日志打印内容
///
///@date：2024/9/19
class _Printer extends PrettyPrinter {
  Map<Level, AnsiColor> colorOfLevel;

  _Printer(this.colorOfLevel);

  @override
  List<String> log(LogEvent event) {
    var messageStr = stringifyMessage(event.message);
    String? stackTraceStr;
    if (event.error != null) {
      if ((errorMethodCount == null || errorMethodCount! > 0)) {
        stackTraceStr = formatStackTrace(
          event.stackTrace ?? StackTrace.current,
          errorMethodCount,
        );
      }
    } else if (methodCount == null || methodCount! > 0) {
      stackTraceStr = formatStackTrace(
        event.stackTrace ?? StackTrace.current,
        methodCount,
      );
    }

    var errorStr = event.error?.toString();

    return _formatAndPrint(
      event.level,
      messageStr,
      errorStr,
      stackTraceStr,
      colorOfLevel,
    );
  }

  List<String> _formatAndPrint(
    Level level,
    String message,
    String? error,
    String? stacktrace,
    Map<Level, AnsiColor> colorOfLevel,
  ) {
    List<String> buffer = [];
    AnsiColor color = colorOfLevel[level] ?? const AnsiColor.none();

    DateTime date = DateTime.now();
    String time = '${date.hour}:${date.minute}:${date.second}';
    List<String> messages = message.split('\n');
    for (var i = 0; i < messages.length; ++i) {
      var line = i == 0 ? '[$time]：${messages[i]}' : messages[i];
      buffer.add(color(line));
    }
    return buffer;
  }
}
