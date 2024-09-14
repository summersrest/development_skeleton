import 'package:flutter/material.dart';
import 'package:get/get.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _snackBarController;

void showSnackBar(
  String content, {
  String? title,
  int durationSeconds = 3,
  Color? backgroundColor,
  bool closePrevious = false,
}) async {
  Widget contentWidget = Text(content);
  if (title != null) {
    contentWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        contentWidget,
      ],
    );
  }

  if (closePrevious) {
    _snackBarController?.close();
  }
  _snackBarController = ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    content: contentWidget,
    duration: Duration(seconds: durationSeconds),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: backgroundColor,
  ))
    ..closed.then((value) {
      if (value != SnackBarClosedReason.hide) {
        _snackBarController = null;
      }
    });
}

void showSnackBarError(
  String content, {
  String? title,
  int durationSeconds = 6,
  bool closePrevious = false,
}) async {
  showSnackBar(
    content,
    title: title,
    durationSeconds: durationSeconds,
    backgroundColor: Colors.red,
    closePrevious: closePrevious,
  );
}
