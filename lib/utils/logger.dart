import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  SimpleLogPrinter();

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.defaultLevelColors[event.level];
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    return [color!('$emoji${event.message}')];
  }
}

final logger = Logger(printer: SimpleLogPrinter());
