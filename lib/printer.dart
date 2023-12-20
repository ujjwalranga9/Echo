import 'package:talker_logger/talker_logger.dart';

class ColoredLoggerFormatter implements LoggerFormatter {
  @override
  String fmt(LogDetails details, TalkerLoggerSettings settings) {
    final msg = details.message?.toString() ?? '';
    final coloredMsg =
    msg.split('\n').map((e) => details.pen.write(e)).toList().join('\n');
    return coloredMsg;
  }
}

final log = TalkerLogger(
  formatter: ColoredLoggerFormatter(),
  settings: TalkerLoggerSettings(
    colors:{
      LogLevel.good: AnsiPen()..green(),
      LogLevel.error: AnsiPen()..red(),
      LogLevel.warning: AnsiPen()..yellow(),
      LogLevel.info: AnsiPen()..blue(),
      LogLevel.critical: AnsiPen()..cyan(),
      LogLevel.debug: AnsiPen()..rgb(r: 1,g: 0.5,b: 0,bg: false),
      LogLevel.verbose: AnsiPen()..white(),
    },
  )
);

logG(String msg) => log.good(msg);
logR(String msg) => log.error(msg);
logY(String msg) => log.warning(msg);
logB(String msg) => log.info(msg);
logC(String msg) => log.critical(msg);
logM(String msg) => log.debug(msg);
logW(String msg) => log.verbose(msg);
logE(String msg) => log.log(msg, pen: AnsiPen()..xterm(49));
