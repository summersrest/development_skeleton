///# 当前是否为调试模式
///
///## 说明：当前是否为调试模式
bool get isDebug {
  bool debug = false;
  assert(() {
    debug = true;
    return true;
  }());
  return debug;
}
