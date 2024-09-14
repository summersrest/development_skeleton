import 'extension.dart';

///# 日期工具类
///
///## 说明：日期工具类
class DateUtil {
  DateUtil._();

  ///# 获取当前的时间戳
  ///
  ///## 说明：获取当前的时间戳
  static int getCurrentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  ///# 获取当前的时间
  ///
  ///## 说明：获取当前的时间
  static String getCurrentTime([String targetFormat = 'YYYY-MM-DD hh:mm:ss']) {
    return timestampToString(getCurrentTimestamp(), targetFormat);
  }

  ///字符串格式化
  static String formatString(String date, [String targetFormat = 'YYYY-MM-DD hh:mm:ss']) {
    if (date.isBlank) return '';
    DateTime dateTime = DateTime.parse(date);
    return timestampToString(dateTime.millisecondsSinceEpoch, targetFormat);
  }

  ///# 时间戳转字符串
  ///
  ///## 说明：时间戳转字符串
  static String timestampToString(int? timestamp, [String targetFormat = 'YYYY-MM-DD hh:mm:ss']) {
    timestamp ??= DateTime.now().millisecondsSinceEpoch;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: false);
    String timeStr = dateTime.toString();
    dynamic dateArr = timeStr.split(' ')[0];
    dynamic timeArr = timeStr.split(' ')[1];

    String year = dateArr.split('-')[0];
    String month = dateArr.split('-')[1];
    String day = dateArr.split('-')[2];

    String hour = timeArr.split(':')[0];
    String minute = timeArr.split(':')[1];
    String second = timeArr.split(':')[2];
    second = second.split('.')[0];

    //处理年
    int countY = 'Y'.allMatches(targetFormat).length;
    if (countY <= 1) {
      year = year.substring(3);
    } else if (countY == 2) {
      year = year.substring(2);
    } else if (countY == 3) {
      year = year.substring(1);
    }

    //去除0开头
    int countM = 'M'.allMatches(targetFormat).length;
    if (countM < 2) {
      month = (int.parse(month)).toString();
    }

    int countD = 'D'.allMatches(targetFormat).length;
    if (countD < 2) {
      day = (int.parse(day)).toString();
    }

    int counth = 'h'.allMatches(targetFormat).length;
    if (counth < 2) {
      hour = (int.parse(hour)).toString();
    }

    int countm = 'm'.allMatches(targetFormat).length;
    if (countm < 2) {
      minute = (int.parse(minute)).toString();
    }

    int counts = 's'.allMatches(targetFormat).length;
    if (counts < 2) {
      second = (int.parse(second)).toString();
    }

    if (countY <= 1) {
      targetFormat = targetFormat.replaceAll('Y', year);
    } else if (countY == 2) {
      targetFormat = targetFormat.replaceAll('YY', year);
    } else if (countY == 3) {
      targetFormat = targetFormat.replaceAll('YYY', year);
    } else {
      targetFormat = targetFormat.replaceAll('YYYY', year);
    }

    targetFormat = targetFormat
        .replaceAll(countM > 1 ? 'MM' : 'M', month)
        .replaceAll(countD > 1 ? 'DD' : 'D', day)
        .replaceAll(counth > 1 ? 'hh' : 'h', hour)
        .replaceAll(countm > 1 ? 'mm' : 'm', minute)
        .replaceAll(counts > 1 ? 'ss' : 's', second);

    return targetFormat;
  }
}
