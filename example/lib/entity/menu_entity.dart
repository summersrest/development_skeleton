import 'package:flutter/material.dart';

class MenuEntity {
  String name;
  IconData iconData;
  VoidCallback? onTap;

  MenuEntity({
    required this.name,
    required this.iconData,
    required this.onTap,
  });
}
