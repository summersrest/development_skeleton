import 'dart:convert';
import 'package:development_skeleton/utils/extension.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

///# 文件存储工具类
///
///## 说明：文件存储工具类
abstract class StoreUtils {
  ///# 获取应用外部缓存文件目录
  ///
  ///## 说明：外部应用的缓存目录，无需任何权限即可访问。无大小限制，可以存放大文件。
  ///        应用卸载时存储的数据会被全部清空。
  /// Android 上对应[getExternalFilesDir]。/storage/emulated/0/Android/data/包名/files
  /// iOS     上对应[NSDocumentDirectory]。/var/mobile/Containers/Data/Application/XXX/Documents
  static Future<String> externalFileDirectory() async {
    if (Platform.isAndroid) {
      Directory? directory = await getExternalStorageDirectory();
      if (null != directory) return directory.path;
      throw UnsupportedError('path not supported');
    }
    if (Platform.isIOS) return (await getApplicationDocumentsDirectory()).path;
    throw UnsupportedError('path not supported on this platform');
  }

  ///# 获取应用外部缓存文件目录
  ///
  ///## 说明：外部应用的缓存目录，无需任何权限即可访问。无大小限制，可以存放大文件。
  ///        应用卸载时存储的数据会被全部清空。
  /// Android 上对应[getExternalCacheDirs]。/storage/emulated/0/Android/data/包名/cache
  /// iOS     上对应[NSDocumentDirectory]。/var/mobile/Containers/Data/Application/XXX/Documents
  static Future<String> externalCacheDirectory() async {
    if (Platform.isAndroid) {
      List<Directory>? directory = await getExternalCacheDirectories();
      if (directory.isNotBlank) return directory!.first.path;
      throw UnsupportedError('path not supported');
    }
    if (Platform.isIOS) return (await getApplicationDocumentsDirectory()).path;
    throw UnsupportedError('path not supported on this platform');
  }

  ///# 获取临时缓存目录
  ///
  ///## 说明：应用缓存目录位于手机的内置存储卡中，无需任何权限即可访问。此目录隐私性最强，外部应用不访问，非root手机对用户同样不可见，
  ///        但是存储空间较小，不要存储较大文件。我们创建的SharedPreference与数据库文件都在此类目录中。
  ///        应用卸载时存储的数据会被全部清空。
  ///        注意：IOS的话，应用杀死时就会被直接清除
  /// Android 上对应[getCacheDir]。/data/user/0/包名/cache
  /// iOS     上对应[NSCachesDirectory]。/var/mobile/Containers/Data/Application/XXX/Library/Caches
  static Future<String> temporaryCacheDirectory() async {
    if (Platform.isAndroid || Platform.isIOS) return (await getTemporaryDirectory()).path;
    throw UnsupportedError('path not supported on this platform');
  }

  ///# 获取临时文件目录
  ///
  ///## 说明：应用临时文件目录位于手机的内置存储卡中，无需任何权限即可访问。此目录隐私性最强，外部应用不访问，非root手机对用户同样不可见，
  ///        但是存储空间较小，不要存储较大文件。应用卸载时存储的数据会被全部清空。
  ///Android 上对应[getFilesDir]。/data/data/包名/files
  ///iOS     上对应[NSApplicationSupportDirectory]。/var/mobile/Containers/Data/Application/XXX/Library/Application Support
  static Future<String> temporaryFileDirectory() async {
    if (Platform.isAndroid || Platform.isIOS) return (await getApplicationSupportDirectory()).path;
    throw UnsupportedError('path not supported on this platform');
  }

  ///# 字符串写入文件
  ///
  ///## 说明：字符串写入文件，若文件不存在，则创建文件。
  /// [file]              要写入的目标文件
  /// [content]           要写入的字符串
  /// [overrideExisting]  是否覆盖已有文件？如果为【true】则直接覆盖当前文件。如果为【false】则在当前文件尾部追加
  /// [encoding]          字符串编码
  static Future writeStringToFile({
    required File file,
    required String content,
    bool overrideExisting = true,
    Encoding encoding = utf8,
  }) async {
    IOSink sink = file.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
    sink.writeln(content);
    await sink.flush();
    await sink.close();
  }

  ///# 从指定文件中读取字符串
  ///
  ///## 说明：从指定文件中读取字符串
  /// [file]      目标文件
  /// [encoding]  字符串编码
  static Future<String> readStringFromFile(File file, {Encoding encoding = utf8}) {
    return file.readAsString(encoding: encoding);
  }

  ///# 从指定大文件中读取字符串
  ///
  ///## 说明：读取大文件时，不一次性加载整个文件到内存中。如此减少内存使用，并提高程序的响应性。
  /// [file]      目标文件
  /// [onData]    读取的每行回调
  /// [encoding]  字符串编码
  /// [onDone]    操作完成回调
  /// [onError]   异常回调
  /// [start]     如果[start]存在，文件将从字节偏移量[start]读取。否则从开始(索引0)开始。
  /// [end]       如果[end]存在，则只读取字节索引[end]以内的字节。否则，直到文件结束。
  static void readLargeStringFromFile({
    required File file,
    required ValueChanged<String> onData,
    Encoding encoding = utf8,
    VoidCallback? onDone,
    ValueChanged<Object>? onError,
    int? start,
    int? end,
  }) {
    var stream = file.openRead(start, end);
    stream.transform(utf8.decoder).transform(const LineSplitter()).listen(onData, onDone: () {
      if (null != onDone) {
        onDone();
      }
    }, onError: (error) {
      if (null != onError) {
        onError(error);
      }
    });
  }

  ///# 从指定文件中读取数据流
  ///
  ///## 说明：从指定文件中读取数据流
  /// [file]  目标文件
  /// [start] 如果[start]存在，文件将从字节偏移量[start]读取。否则从开始(索引0)开始。
  /// [end]   如果[end]存在，则只读取字节索引[end]以内的字节。否则，直到文件结束。
  static Stream<List<int>> readStreamFromFile(File file, [int? start, int? end]) {
    Stream<List<int>> stream = file.openRead(start, end);
    return stream;
  }

  ///# 从文件中读取字节流
  ///
  ///## 说明：从文件中读取字节流。例如从File中读取图片，显示到组件中：
  ///
  /// var file = File('path_to_your_image_file');
  /// var bytes = await StoreUtils.readUintFromFile(file);
  /// Center(
  ///   child: Image.memory(bytes),
  /// )
  ///
  /// [file]  目标文件
  static Future<Uint8List> readUintFromFile(File file) {
    return file.readAsBytes();
  }

  ///# 将字节流写入指定文件
  ///
  ///## 说明：将字节流写入指定文件。例如将图片写入指定File中：
  ///
  /// [file]   目标文件
  /// [bytes]  要写入的字节流
  static Future writeUintToFile({required File file, required Uint8List bytes}) async {
    await file.writeAsBytes(bytes.buffer.asUint8List());
  }

  ///# 将字节流写入指定文件
  ///
  ///## 说明：将字节流写入指定文件。例如将图片写入指定File中：
  ///
  /// [file]   目标文件
  /// [bytes]  要写入的字节流
  static Future writeByteToFile({required File file, required ByteData bytes}) async {
    await file.writeAsBytes(bytes.buffer.asUint8List());
  }

  ///# 从资源文件中读取字符串
  ///
  ///## 说明：从资源文件中读取字符串
  ///
  /// [path]   文件路径：'assets/name_data.json'
  /// [cache]  是否缓存
  static Future readStringFromResource(String path, {bool cache = true}) {
    return rootBundle.loadString(path, cache: cache);
  }

  ///# 从资源文件中读取字节流
  ///
  ///## 说明：从资源文件中读取字节流
  ///
  /// [path]   文件路径：'assets/name_data.json'
  static Future<ByteData> readByteFromResource(String path) {
    return rootBundle.load(path);
  }
}
