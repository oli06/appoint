import 'dart:convert';

import 'package:logger/logger.dart';

Logger getLogger(String className) {
  return Logger(
    printer: AppointPrinter(messagePrefix: className, printTime: true),
  );
}

class AppointPrinter extends LogPrinter {
  static final levelPrefixes = {
    Level.verbose: '[V]',
    Level.debug: '[D]',
    Level.info: '[I]',
    Level.warning: '[W]',
    Level.error: '[E]',
    Level.wtf: '[WTF]',
  };

  final String messagePrefix;
  final bool printTime;

  AppointPrinter({
    this.messagePrefix = "",
    this.printTime = false,
  });

  @override
  void log(LogEvent event) {
    var messageStr = stringifyMessage(event.message);
    var errorStr = event.error != null ? "  ERROR: ${event.error}" : "";
    String prefix = messagePrefix;
    if (printTime) {
      prefix = DateTime.now().toString() + " " + prefix;
    }
    println("${levelPrefixes[event.level]} $prefix $messageStr$errorStr");
  }

  String stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent(null);
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }
}
