import 'dart:io';

import 'package:development_skeleton/development_skeleton.dart';

///# 文件处理
///
///@date 2024/9/20
class StoreSampleController extends BaseController {
  @override
  init() {}

  /// 字符串写入文件（覆盖）
  Future saveToFileOverride() async {
    File file = File('${await StoreUtils.externalFileDirectory()}/test.txt');
    StoreUtils.writeStringToFile(file: file, content: '字符串写入（替换）：${DateUtil.getCurrentTime()}');
  }

  /// 字符串写入文件（追加）
  Future saveToFile() async {
    File file = File('${await StoreUtils.externalFileDirectory()}/test.txt');
    StoreUtils.writeStringToFile(
      file: file,
      content: '字符串写入（追加）：${DateUtil.getCurrentTime()}',
      overrideExisting: false,
    );
  }

  /// 从文件中读取字符串
  Future readString() async {
    File file = File('${await StoreUtils.externalFileDirectory()}/test.txt');
    String txt = await StoreUtils.readStringFromFile(file);
    Log.i(txt);
  }

  /// 大文件按行读取
  Future readStringLarge() async {
    File file = File('${await StoreUtils.externalFileDirectory()}/test.txt');
    StoreUtils.readLargeStringFromFile(
      file: file,
      onData: (line) {
        Log.simpleI(line);
      },
      onDone: () => Log.simpleI('读取完成'),
      onError: (error) => Log.e(error),
    );
  }

  /// 从资源文件中读取字符串
  Future readFromResource() async {
    String txt = await StoreUtils.readStringFromResource('assets/city.txt');
    Log.i(txt);
  }
}
