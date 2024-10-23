///# 防双击
///
///## 说明：防双击
abstract class MultiClickUtils {
  static DateTime? _lastClickTime;

  ///# 判断是否为双击
  static bool isMultiClick({int intervalMilliseconds = 500}) {
    if (_lastClickTime == null ||
        DateTime.now().difference(_lastClickTime!) > Duration(milliseconds: intervalMilliseconds)) {
      _lastClickTime = DateTime.now();
      return false;
    }
    return true;
  }
}
