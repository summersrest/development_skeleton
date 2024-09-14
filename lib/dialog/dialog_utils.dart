import 'package:development_skeleton/utils/extension.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:decimal/decimal.dart';
import '../widget/show_snack_bar.dart';

///# 弹窗工具类
///
///## 说明：弹出弹窗的工具类
///
///@date：2023/9/15
class DialogUtils {
  DialogUtils._();

  ///# 显示确认弹窗
  ///
  ///## 说明：显示确认弹窗
  ///
  ///@date：2023/9/15
  static Future<bool?>? showConfirmDialog({
    //标题
    String? title,
    //提示内容
    String? content,
    //确定按钮文字
    String? positiveText,
    //确定按钮回调
    VoidCallback? onPositive,
    //取消按钮文字
    String? negativeText,
    //取消按钮回调
    VoidCallback? onNegative,
    //是否隐藏取消按钮
    bool isHideCancel = false,
    //点击空白区域是否关闭弹窗
    bool isDismissTouchOutside = true,
  }) {
    if (null == Get.context) return null;
    return showDialog(
      context: Get.context!,
      barrierDismissible: isDismissTouchOutside,
      builder: (context) {
        return AlertDialog(
          title: null != title ? Center(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))) : null,
          titlePadding: const EdgeInsets.only(top: 15, right: 20, left: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text(content ?? "")],
          ),
          contentPadding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
          actionsPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          actions: [
            Container(
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black26, width: 0.6))),
              height: 45,
              child: Row(
                children: [
                  isHideCancel
                      ? const SizedBox()
                      : Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () {
                              if (null != onNegative) {
                                onNegative();
                              }
                              return Navigator.of(context).pop(false);
                            },
                            child: Text(
                              negativeText ?? "取消",
                              style: const TextStyle(color: Colors.black38),
                            ),
                          ),
                        ),
                  Container(width: 0.6, height: double.infinity, color: Colors.black26),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        if (null != onPositive) {
                          onPositive();
                        }
                        return Navigator.of(context).pop(true);
                      },
                      child: Text(
                        positiveText ?? "确定",
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  ///# 底部弹窗
  ///
  ///## 说明：底部弹出IOS样式的选择框
  ///
  ///@date：2023/9/15
  static Future? showBottomSheet<T>({
    required List<T> children,
    String Function(T item)? textFormatter,
  }) {
    if (null == Get.context) return null;
    return showCupertinoModalPopup(
      context: Get.context!,
      builder: (context) {
        return CupertinoActionSheet(
          actions: children
              .map((e) => CupertinoActionSheetAction(
                    onPressed: () => Navigator.of(context).pop(e),
                    child: Text(null != textFormatter ? textFormatter(e) : e.toString()),
                  ))
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("取消"),
          ),
        );
      },
    );
  }

  ///# 弹出List列表弹窗
  ///
  ///## 说明：弹出List列表弹窗
  ///
  ///@date：2023/9/15
  static Future? showListDialog<T>({
    String? title,
    required List<T> children,
    String Function(T item)? textFormatter,
    //点击空白区域是否关闭弹窗
    bool isDismissTouchOutside = true,
  }) {
    if (null == Get.context) return null;
    return showDialog(
      context: Get.context!,
      barrierDismissible: isDismissTouchOutside,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Builder(builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 标题栏
                Container(
                  width: double.infinity,
                  height: null,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      // 标题
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            title ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      // 关闭按钮
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height / 2,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      return ListTile(
                        title:
                            Text(null != textFormatter ? textFormatter(children[index]) : children[index].toString()),
                        onTap: () => Get.back(result: children[index]),
                      );
                    },
                    itemCount: children.length,
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  ///# Android自动更新弹窗
  ///
  ///## 说明：Android自动更新弹窗
  ///
  ///@date：2023/9/29
  static Future? showVersionUpdateDialog({
    required int version,
    required String updateLog,
    required String downloadUrl,
    required String savePath,
  }) {
    if (null == Get.context) return null;
    return showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/update_bg_top_1.png'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  border: Border.all(color: Colors.transparent, width: 0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //版本号
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: '是否升级到',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          TextSpan(
                            text: 'v$version',
                            style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: '版本？',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    //更新日志
                    const Text(
                      '更新内容：',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        updateLog,
                        style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                      ),
                    ),
                    //底部按钮
                    _UpdateDialogBottomView(
                      downloadUrl: downloadUrl,
                      savePath: savePath,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ///# 长按弹出的列表菜单
  ///
  ///## 说明：长按后在手指长按处弹出的列表菜单，一般用于列表长按的一系列操作，或者图片长按弹出菜单
  ///
  ///@date：2023/10/7
  static showLongPressedPopupMenu({
    ///当前页面的Context
    required BuildContext context,

    ///长按开始回调的详细内容
    required LongPressStartDetails detail,

    ///弹窗item列表
    required List<LongPressedPopupMenuItem> items,
  }) {
    //获取手指长按的位置
    final RelativeRect position = RelativeRect.fromLTRB(
      detail.globalPosition.dx,
      detail.globalPosition.dy,
      detail.globalPosition.dx,
      0,
    );
    //LongPressedPopupMenuItem对象转换为PopupMenuItem对象
    List<PopupMenuItem> popupMenuItems = items.map((item) {
      return PopupMenuItem(
        onTap: () {
          // Navigator.of(context).pop();
          item.onTap();
        },
        child: Text(item.item),
      );
    }).toList();
    //弹出菜单
    return showMenu(context: context, position: position, items: popupMenuItems, useRootNavigator: true);
  }
}

///# Android自动更新底部布局
///
///## 说明：包含“取消”，“确定”两个按钮。点击“确定”按钮后切换为进度条。
///
///@date：2023/9/29
class _UpdateDialogBottomView extends StatefulWidget {
  final String downloadUrl;
  final String savePath;

  const _UpdateDialogBottomView({
    required this.downloadUrl,
    required this.savePath,
  });

  @override
  State<_UpdateDialogBottomView> createState() => _UpdateDialogBottomViewState();
}

class _UpdateDialogBottomViewState extends State<_UpdateDialogBottomView> {
  ///显示下载按钮
  bool _showDownloadButton = true;

  ///显示进度条
  bool _showProgressBar = false;

  ///下载进度监听
  final ValueNotifier<String> _progress = ValueNotifier('0');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          Offstage(
            offstage: !_showProgressBar,
            child: ValueListenableBuilder(
              valueListenable: _progress,
              builder: (BuildContext context, value, Widget? child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '下载进度：${Decimal.parse(_progress.value) * Decimal.parse('100')}%',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: double.parse(_progress.value),
                      minHeight: 10,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                      backgroundColor: const Color(0x00ff7532).withOpacity(0.2),
                    )
                  ],
                );
              },
            ),
          ),
          Offstage(
            offstage: !_showDownloadButton,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      backgroundColor: const Color(0xfff1f1f1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('取消', style: TextStyle(color: Colors.orange)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //隐藏按钮，显示进度条
                      if (mounted) {
                        setState(() {
                          _showDownloadButton = false;
                          _showProgressBar = true;
                        });
                      }
                      //开始下载
                      try {
                        await Dio().download(
                          widget.downloadUrl,
                          widget.savePath,
                          onReceiveProgress: (receive, total) {
                            //刷新进度条
                            _progress.value = (receive / total).fix(2);
                          },
                        );
                        Get.back();
                        //安装apk
                        // InstallPlugin.install(widget.savePath);
                      } catch (e) {
                        //下载失败
                        Get.back();
                        showSnackBarError('下载失败');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      backgroundColor: Colors.orange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('确定'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///# 长按菜单子item对象
///
///## 说明：长按菜单子item对象
///
///@date：2023/10/7
class LongPressedPopupMenuItem {
  ///文字
  final String item;

  ///回调监听
  final VoidCallback onTap;

  LongPressedPopupMenuItem(this.item, this.onTap);
}
