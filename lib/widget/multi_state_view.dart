import 'package:development_skeleton/base/base_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiStateView<T extends BaseController> extends StatelessWidget {
  final T controller;
  final Widget Function() contentBuilder;
  final Widget Function()? emptyBuilder;
  final Widget Function()? errorBuilder;
  final Widget Function()? loadingBuilder;
  final String? tag;

  const MultiStateView({
    super.key,
    required this.controller,
    required this.contentBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      tag: tag,
      builder: (_) {
        switch (controller.viewState) {
          case ViewState.loading:
            return null != loadingBuilder ? loadingBuilder!() : const LoadingView();
          case ViewState.content:
            return contentBuilder();
          case ViewState.empty:
            return null != emptyBuilder ? emptyBuilder!() : const EmptyView();
          case ViewState.error:
            return null != errorBuilder ? errorBuilder!() : const ErrorView();
        }
      },
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(radius: 15),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_empty_outlined),
          SizedBox(width: 10),
          Text('数据为空'),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 10),
          Text('数据异常'),
        ],
      ),
    );
  }
}
