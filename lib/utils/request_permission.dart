import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

///# 权限申请
///
///## 说明：权限申请
class RequestPermission {
  RequestPermission._();

  static RequestPermission instance = RequestPermission._();

  Future<bool> request({
    /// 权限列表
    required List<Permission> permissions,
    VoidCallback? onGranted,
    ValueChanged<List<Permission>>? onDenied,
    ValueChanged<List<Permission>>? onPermanentlyDenied,
  }) async {
    if (permissions.isEmpty) {
      if (null != onGranted) {
        onGranted();
      }
      return Future(() => true);
    }

    List<Permission> temps = [];
    for (Permission permission in permissions) {
      var status = await permission.status;
      if (!status.isGranted) temps.add(permission);
    }

    if (temps.isEmpty) {
      if (null != onGranted) {
        onGranted();
      }
      return Future(() => true);
    }

    Map<Permission, PermissionStatus> statuses = await temps.request();
    //拒绝并且可以重新申请的权限
    List<Permission> deniedList = statuses.keyToListWhere((status) => status == PermissionStatus.denied);
    if (null != onDenied && deniedList.isNotEmpty) {
      onDenied(deniedList);
    }
    //永久拒绝的权限
    List<Permission> permanentlyList = statuses.keyToListWhere((status) => status == PermissionStatus.permanentlyDenied);
    if (null != onPermanentlyDenied && permanentlyList.isNotEmpty) {
      onPermanentlyDenied(permanentlyList);
    }

    List<Permission> grantedList = statuses.keyToListWhere((status) => status == PermissionStatus.granted);
    //所有权限是否都被授予？
    bool result = grantedList.length == statuses.length;
    if (null != onGranted && result) {
      onGranted();
    }
    return Future(() => result);
  }
}

extension Ext on Map<Permission, PermissionStatus> {
  List<Permission> keyToListWhere(bool Function(PermissionStatus status) func) {
    List<Permission> result = [];
    forEach((key, value) {
      if (func(value)) {
        result.add(key);
      }
    });
    return result;
  }
}
