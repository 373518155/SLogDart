import 'package:sprintf/sprintf.dart';

/// SLog类
/// 使用方式:
/// SLog.info('Hello %s, I am %d years old!', ['Peter', 2]);
/// 或
/// SLog.info('Hello $name, I am $age years old!');
///
/// 输出:
/// [2020-04-06 16:36:23.555][main.dart][00053]Hello Peter, I am 2 years old!
///
/// 参考：
/// Flutter: Get line number for print() statements, Android Studio
/// https://stackoverflow.com/questions/51234734/flutter-get-line-number-for-print-statements-android-studio
class SLog {
  static void info(String format, [List params]) {
    params ??= [];

    /* The trace comes with multiple lines of strings, we just want the first line, which has the information we need */
    var traceString = StackTrace.current.toString().split('\n')[1];

    /* Search through the string and find the index of the file name by looking for the '.dart' regex */
    var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z0-9_\-]+.dart'));  // 最后还要考虑有些文件名有下划线或减号

    var fileInfo = traceString.substring(indexOfFileName);

    var listOfInfos = fileInfo.split(':');

    /* Splitting fileInfo by the character ":" separates the file name, the line number and the column counter nicely.
      Example: main.dart:5:12
      To get the file name, we split with ":" and get the first index
      To get the line number, we would have to get the second index
      To get the column number, we would have to get the third index
    */

    var fileName = listOfInfos[0];
    var lineNumber = int.parse(listOfInfos[1]);

    var content = sprintf(format, params);
    print(sprintf('[%s][%s][%05d]%s',
        [
          DateTime.now().toString().substring(0, 23),  // 本来精确到微秒的，但不用这么高精度
          fileName,
          lineNumber,
          content
        ]));
  }
}
