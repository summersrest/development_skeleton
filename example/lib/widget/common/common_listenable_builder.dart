/*
 *      ProActive Project
 *
 *      Copyright (C) SCSK Corporation,
 *      All Rights Reserved.
 */
import 'package:flutter/material.dart';

class CommonListenableBuilder extends StatelessWidget {
  final Listenable? listenable;
  final TransitionBuilder builder;
  final Widget? child;

  const CommonListenableBuilder({
    super.key,
    required this.listenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return null != listenable
        ? ListenableBuilder(
            listenable: listenable!,
            builder: builder,
          )
        : builder(context, child);
  }
}
