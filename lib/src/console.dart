import 'package:logger/logger.dart';

class ConsolePrinter extends PrettyPrinter {
  ConsolePrinter(
      {int methodCount = 2,
      this.skipMethods = 0,
      int errorMethodCount = 8,
      int lineLength = 120,
      bool colors = true,
      bool printEmojis = true,
      bool printTime = false})
      : super(
            methodCount: methodCount,
            errorMethodCount: errorMethodCount,
            lineLength: lineLength,
            colors: colors,
            printEmojis: printEmojis,
            printTime: printTime);

  final int skipMethods;

  @override
  String formatStackTrace(StackTrace stackTrace, int methodCount) {
    var lines = stackTrace.toString().split("\n");

    var formatted = <String>[];
    var count = 0;
    var printed = 0;
    for (var line in lines) {
      var match = PrettyPrinter.stackTraceRegex.matchAsPrefix(line);
      if (match != null) {
        if (match.group(2).startsWith('package:logger')) {
          continue;
        }
        if (count > (skipMethods - 1)) {
          var newLine = ("#$printed   ${match.group(1)} (${match.group(2)})");
          formatted.add(newLine.replaceAll('<anonymous closure>', '()'));
          ++printed;
        }

        if (++count == methodCount) {
          break;
        }
      } else {
        formatted.add(line);
      }
    }
    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }
}
