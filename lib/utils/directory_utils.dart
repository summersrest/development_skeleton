import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

///# 目录工具类
///
///## 说明：目录工具类
abstract class DirectoryUtils {
  ///# 获取应用外部缓存文件目录
  ///
  ///## 说明：Android、IOS 外部存储目录
  static Future<String> externalFilePath() async {
    if (Platform.isAndroid) return (await getExternalStorageDirectory())?.path ?? '';
    if (Platform.isIOS) return (await getTemporaryDirectory()).path;
    throw UnsupportedError('path not supported on this platform');
  }
}
