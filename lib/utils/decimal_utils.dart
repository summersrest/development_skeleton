import 'package:decimal/decimal.dart';

///# 高精度计算工具类
///
///## 说明：高精度计算工具类
abstract class DecimalUtils {
  ///# 加法
  ///
  ///## 说明：加法
  static String add(val1, val2) {
    Decimal decimal1 = Decimal.parse(double.tryParse(val1.toString()) == null ? '0' : val1.toString());
    Decimal decimal2 = Decimal.parse(double.tryParse(val2.toString()) == null ? '0' : val2.toString());
    return (decimal1 + decimal2).toString();
  }

  ///# 减法
  ///
  ///## 说明：减法
  static String subtract(val1, val2) {
    Decimal decimal1 = Decimal.parse(double.tryParse(val1.toString()) == null ? '0' : val1.toString());
    Decimal decimal2 = Decimal.parse(double.tryParse(val2.toString()) == null ? '0' : val2.toString());
    return (decimal1 - decimal2).toString();
  }

  ///#  乘法
  ///
  ///## 说明： 乘法
  static String multiply(val1, val2) {
    Decimal decimal1 = Decimal.parse(double.tryParse(val1.toString()) == null ? '0' : val1.toString());
    Decimal decimal2 = Decimal.parse(double.tryParse(val2.toString()) == null ? '0' : val2.toString());
    return (decimal1 * decimal2).toString();
  }

  ///#  除法
  ///
  ///## 说明： 除法
  static String divide(val1, val2) {
    Decimal decimal1 = Decimal.parse(double.tryParse(val1.toString()) == null ? '0' : val1.toString());
    Decimal decimal2 = Decimal.parse(double.tryParse(val2.toString()) == null ? '0' : val2.toString());
    final result = decimal1 / decimal2;
    if (result.isInteger) {
      return result.toString();
    } else {
      return result.toDouble().toString();
    }
  }
}
